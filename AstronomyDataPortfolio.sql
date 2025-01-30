-- Metadata can be found at: https://www.astronexus.com/projects/hyg-details
-- To run each section, highlight the lines you want to run, and then click 'execute script'
-- Running entire script without highlighting leads to an error

-- Visualise whole database
SELECT * FROM hyg_star_catalog

-- Visualise only Gliese catalog of nearby stars
SELECT id,gl,proper,ra,dec,dist,pmra,pmdec,rv,mag,absmag,spect,ci,x,y,z,vx,vy,vz,rarad,decrad,pmrarad,pmdecrad,bayer,flam,con,comp,comp_primary,base,lum,var,var_min,var_max
FROM hyg_star_catalog
WHERE gl!=''

-- Visualise only the Bayer/Flamsteed designation and order by distance ascending
SELECT id,bf,proper,ra,dec,dist,pmra,pmdec,rv,mag,absmag,spect,ci,x,y,z,vx,vy,vz,rarad,decrad,pmrarad,pmdecrad,bayer,flam,con,comp,comp_primary,base,lum,var,var_min,var_max
FROM hyg_star_catalog
WHERE bf!=''
ORDER BY dist

-- Create new table containing gl stars only
CREATE TABLE gl_stars AS
	SELECT id,gl,proper,ra,dec,dist,pmra,pmdec,rv,mag,absmag,spect,ci,x,y,z,vx,vy,vz,rarad,decrad,pmrarad,pmdecrad,bayer,flam,con,comp,comp_primary,base,lum,var,var_min,var_max 
	FROM hyg_star_catalog
	WHERE gl!=''
	
-- Create new table containing bf stars only
CREATE TABLE bf_stars AS
	SELECT id,bf,proper,ra,dec,dist,pmra,pmdec,rv,mag,absmag,spect,ci,x,y,z,vx,vy,vz,rarad,decrad,pmrarad,pmdecrad,bayer,flam,con,comp,comp_primary,base,lum,var,var_min,var_max 
	FROM hyg_star_catalog
	WHERE bf!=''

-- Show all gl stars with proper names, ordered by absolute magnitude.
SELECT gl, proper, con, dist, MAX(absmag) AS MaxAbsMag FROM gl_stars
WHERE proper!=''
GROUP BY gl, proper, con, dist
ORDER BY MaxAbsMag DESC

-- Temporary Table
DROP TABLE IF EXISTS gl_stars_maxabsmag
CREATE TABLE gl_stars_maxabsmag
(
	gl text,
	proper text,
	con text,
	dist double precision,
	maxabsmag double precision
)

INSERT INTO gl_stars_maxabsmag
SELECT gl, proper, con, dist, MAX(absmag) AS MaxAbsMag FROM gl_stars
WHERE proper!=''
GROUP BY gl, proper, con, dist
ORDER BY MaxAbsMag DESC

SELECT * FROM gl_stars_maxabsmag

-- Create View to store data to visualise later
CREATE VIEW gl_stars_maxabsmag_view AS
SELECT * FROM gl_stars_maxabsmag