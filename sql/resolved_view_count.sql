CREATE TEMPORARY TABLE staging.view_count
SELECT
    page_id,
    views
FROM (
    SELECT
        page_namespace,
        page_title,
        SUM(views) AS views
    FROM staging.page_name_views_dupes
    WHERE page_namespace = 0
    GROUP BY 1,2
) AS group_page_name_views
INNER JOIN enwiki.page USING (page_namespace, page_title);

CREATE TEMPORARY TABLE staging.view_count2 SELECT * FROM staging.view_count;
CREATE UNIQUE INDEX page_id ON staging.view_count2 (page_id);

SELECT
    direct.page_id,
    direct.views + IFNULL(SUM(redirected.views), 0) AS views,
    direct.views AS direct_views,
    IFNULL(SUM(redirected.views), 0) AS views_from_redirects,
    COUNT(redirected.page_id) AS redirects
FROM staging.view_count direct
INNER JOIN staging.inlink_count redirect_info ON
    redirect_info.redirect_id = direct.page_id
LEFT JOIN staging.view_count2 redirected ON
    redirected.page_id = redirect_info.page_id
GROUP BY direct.page_id;
