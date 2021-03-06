SELECT
    article.page_id,
    article.page_namespace,
    article.page_title,
    cl.cl_to AS category,
    cl.cl_type AS category_type,
    DATE_FORMAT(cl.cl_timestamp, "%Y%m%d%H%i%S") AS last_update,
    SUBSTRING_INDEX(cl.cl_to, "-", 1) AS importance
FROM categorylinks cl
JOIN page talkpage ON
    talkpage.page_namespace = 1 AND
    cl.cl_from = talkpage.page_id
JOIN page article ON
    article.page_namespace = 0 AND
    article.page_title = talkpage.page_title
WHERE
    cl.cl_to LIKE "Top-importance%articles" OR
    cl.cl_to LIKE "High-importance%articles" OR
    cl.cl_to LIKE "Mid-importance%articles" OR
    cl.cl_to LIKE "Low-importance%articles" OR
    cl.cl_to LIKE "Unknown-importance%articles";
