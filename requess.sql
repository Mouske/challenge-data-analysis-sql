-- Pourcentage par forme juridique
SELECT 
    CAST(JuridicalForm AS INT) AS "JuridicalForm", 
    ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM enterprise), 2) AS "percentage",
	Description
	FROM 
	    enterprise
		LEFT JOIN (
			SELECT 
				Code,
				Description
				FROM
					code
				WHERE
					Language = "FR"
					AND
					Category = "JuridicalForm"
		) AS tmp_code ON tmp_code.Code = enterprise.JuridicalForm
	GROUP BY 
	    JuridicalForm
	ORDER BY 
		percentage
		DESC
;
-- Top 10 communes accueillant le plus d'entreprises
SELECT a.MunicipalityNL, COUNT(*) AS nb
FROM address a
JOIN enterprise e ON e.EnterpriseNumber = a.EntityNumber
GROUP BY a.MunicipalityNL
ORDER BY nb DESC
LIMIT 10;

-- Top secteurs d’activité (NACE code)
SELECT 
        vc.Description,
        COUNT(DISTINCT fa.EntityNumber) * 100.0 / (
            SELECT COUNT(*) FROM enterprise WHERE JuridicalForm IS NOT NULL
        ) AS percentage
    FROM 
        activity fa
    JOIN 
        code vc ON CAST(fa.NaceCode AS TEXT) = vc.Code
    WHERE 
        fa.Classification = 'MAIN'
        AND vc.Language = 'FR'
    GROUP BY 
        vc.Description
    ORDER BY 
        percentage DESC
    LIMIT 10;