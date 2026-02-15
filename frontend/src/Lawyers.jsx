import { useState, useEffect } from 'react'
import axios from 'axios'
import { useAuth } from './AuthContext'
import './Lawyers.css'

// Import images from your local folder
import lawyerDefault from './images/img5.jpg'
import articleImg1 from './images/img8.jpg'
import articleImg2 from './images/img7.jpg'
import articleImg3 from './images/img10.jpg'
import heroImage from './images/img6.jpg'

function Lawyers() {
  const [lawyers, setLawyers] = useState([])
  const [form, setForm] = useState({ name: '', specialty: '', location: '' })
  const [loading, setLoading] = useState(false)
  const [search, setSearch] = useState('')
  const [filter, setFilter] = useState('')
  const { user, logout } = useAuth()

  useEffect(() => {
    fetchLawyers()
  }, [])

  const fetchLawyers = async () => {
    try {
      setLoading(true)
      const res = await axios.get('/api/lawyers')
      setLawyers(res.data || [])
    } catch (err) {
      console.error('Failed to fetch lawyers:', err)
    } finally {
      setLoading(false)
    }
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    if (!form.name) return
    try {
      await axios.post('/api/lawyers', form)
      setForm({ name: '', specialty: '', location: '' })
      fetchLawyers()
    } catch (err) {
      console.error('Failed to add lawyer:', err)
    }
  }

  // Filter + search
  const filteredLawyers = lawyers.filter((l) => {
    const matchesSearch =
      l.name?.toLowerCase().includes(search.toLowerCase()) ||
      l.specialty?.toLowerCase().includes(search.toLowerCase())
    const matchesFilter = filter ? l.location === filter : true
    return matchesSearch && matchesFilter
  })

  return (
    <div className="app-container">
      {/* Modern Navigation Bar */}
      <nav className="navbar">
        <div className="nav-content">
          <div className="nav-logo">
            <span className="logo-icon">⚖️</span>
            <span className="logo-text">LawPoint</span>
          </div>
          <ul className="nav-menu">
            <li className="nav-item active"><a href="#home">Home</a></li>
            <li className="nav-item"><a href="#lawyers">Find Lawyers</a></li>
            <li className="nav-item"><a href="#services">Services</a></li>
            <li className="nav-item"><a href="#about">About</a></li>
            <li className="nav-item"><a href="#contact">Contact</a></li>
          </ul>
          <div className="nav-user">
            <div className="user-info">
              <span className="user-avatar">{user?.name?.charAt(0).toUpperCase()}</span>
              <span className="user-name">{user?.name}</span>
            </div>
            <button onClick={logout} className="logout-btn">
              <span>Logout</span>
              <span className="logout-icon">→</span>
            </button>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <div className="hero-section" id="home">
        <div
          className="hero-banner"
          style={{ backgroundImage: `url(${heroImage})` }}
        >
          <div className="hero-content">
            <h1 className="hero-title">Find Your Trusted Legal Expert</h1>
            <p className="hero-subtitle">Connect with experienced lawyers across the nation for all your legal needs</p>
            <div className="hero-buttons">
              <button className="hero-btn primary">Find Lawyers</button>
              <button className="hero-btn secondary">Learn More</button>
            </div>
          </div>
        </div>
      </div>

      {/* Stats */}
      <div className="stats-bar">
        <div className="stat-item">
          <div className="stat-icon">👨‍⚖️</div>
          <h3 className="stat-number">{lawyers.length}+</h3>
          <p className="stat-label">Expert Lawyers</p>
        </div>
        <div className="stat-item">
          <div className="stat-icon">🏆</div>
          <h3 className="stat-number">95%</h3>
          <p className="stat-label">Success Rate</p>
        </div>
        <div className="stat-item">
          <div className="stat-icon">⚖️</div>
          <h3 className="stat-number">15+</h3>
          <p className="stat-label">Practice Areas</p>
        </div>
        <div className="stat-item">
          <div className="stat-icon">🌟</div>
          <h3 className="stat-number">1000+</h3>
          <p className="stat-label">Happy Clients</p>
        </div>
      </div>

      {/* Form */}
      <form onSubmit={handleSubmit} className="lawyer-form">
        <h2>Add New Lawyer</h2>
        <div className="form-group">
          <input
            type="text"
            placeholder="Name *"
            value={form.name}
            onChange={(e) => setForm({ ...form, name: e.target.value })}
            required
          />
          <input
            type="text"
            placeholder="Specialty"
            value={form.specialty}
            onChange={(e) => setForm({ ...form, specialty: e.target.value })}
          />
          <input
            type="text"
            placeholder="Location"
            value={form.location}
            onChange={(e) => setForm({ ...form, location: e.target.value })}
          />
        </div>
        <button type="submit" className="add-btn">Add Lawyer</button>
      </form>

      {/* Search & Filter */}
      <div className="filter-bar">
        <input
          type="text"
          placeholder="Search by name or specialty..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
        />
        <select value={filter} onChange={(e) => setFilter(e.target.value)}>
          <option value="">All Locations</option>
          <option value="Colombo">Colombo</option>
          <option value="Kandy">Kandy</option>
          <option value="Galle">Galle</option>
        </select>
      </div>

      {/* Lawyers List */}
      <div className="lawyer-list" id="lawyers">
        <div className="section-header">
          <h2 className="section-title">Our Expert Lawyers</h2>
          <p className="section-subtitle">Connect with {filteredLawyers.length} qualified legal professionals</p>
        </div>
        {loading && <p className="info-text">Loading...</p>}
        {!loading && filteredLawyers.length === 0 && (
          <p className="info-text">No lawyers found. Try adding one!</p>
        )}
        <div className="lawyer-cards">
          {filteredLawyers.map((lawyer) => (
            <div key={lawyer._id || lawyer.id} className="lawyer-card">
              <img
                src={lawyer.photo || lawyerDefault}
                alt={lawyer.name}
                className="lawyer-photo"
              />
              <h3>{lawyer.name}</h3>
              <p><strong>Specialty:</strong> {lawyer.specialty || '—'}</p>
              <p><strong>Location:</strong> {lawyer.location || '—'}</p>
              <div className="lawyer-card-footer">
                <div className="stars">⭐⭐⭐⭐☆</div>
                <button className="contact-btn">Contact</button>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Law Types Section */}
      <section className="law-types" id="services">
        <div className="section-header">
          <h2 className="section-title">Practice Areas</h2>
          <p className="section-subtitle">Comprehensive legal services across multiple specializations</p>
        </div>
        <div className="law-type-grid">
          <div className="law-type-card">
            <h3>⚖️ Criminal Law</h3>
            <p>Protecting your rights and defending justice with experienced advocates.</p>
          </div>
          <div className="law-type-card">
            <h3>🏢 Corporate Law</h3>
            <p>From startups to global firms — expert advice for your business needs.</p>
          </div>
          <div className="law-type-card">
            <h3>🏠 Civil Law</h3>
            <p>Resolving disputes and upholding fairness in everyday life matters.</p>
          </div>
          <div className="law-type-card">
            <h3>💍 Family Law</h3>
            <p>Compassionate guidance for marriage, divorce, and guardianship cases.</p>
          </div>
          <div className="law-type-card">
            <h3>🌎 Immigration Law</h3>
            <p>Helping individuals navigate visa, residency, and citizenship issues.</p>
          </div>
          <div className="law-type-card">
            <h3>🏗️ Property Law</h3>
            <p>Ensuring smooth transactions and protecting ownership rights.</p>
          </div>
        </div>
      </section>

      {/* Articles Section */}
      <section className="articles-section">
        <h2>Legal Insights & Articles</h2>
        <div className="articles-grid">
          <div className="article-card">
            <img src={articleImg1} alt="Article" />
            <h3>Understanding Your Rights as a Citizen</h3>
            <p>Learn about fundamental legal rights that protect you every day.</p>
            <button>Read More</button>
          </div>
          <div className="article-card">
            <img src={articleImg2} alt="Article" />
            <h3>How to Choose the Right Lawyer</h3>
            <p>Tips to find the perfect legal representative for your case.</p>
            <button>Read More</button>
          </div>
          <div className="article-card">
            <img src={articleImg3} alt="Article" />
            <h3>Corporate Law Trends in 2025</h3>
            <p>Discover how businesses are adapting to new legal regulations.</p>
            <button>Read More</button>
          </div>
        </div>
      </section>

      {/* Call to Action */}
      <section className="cta-section">
        <div>
          <h2>Need Legal Assistance?</h2>
          <p>Find your ideal lawyer today or register as a professional with LawPoint.</p>
          <button className="cta-btn">Get Started</button>
        </div>
      </section>

      <footer className="footer">
        © {new Date().getFullYear()} LawPoint. All rights reserved.
      </footer>
    </div>
  )
}

export default Lawyers
