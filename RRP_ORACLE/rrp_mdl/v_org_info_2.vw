CREATE OR REPLACE FORCE VIEW RRP_MDL.V_ORG_INFO_2 AS
WITH TMP_ORG_INFO (ST_ORG_ID,F_ORG_ID,ORG_BF,ORG_ID,ORG_AFT,FIN_PERMIT_NO,YBT_FLG,IF_ROLL,LVL)
       AS(SELECT ORG_ID          AS ST_ORG_ID,     --初始机构，用作关联用
                 CASE WHEN A.YBT_FLG ='Y'
                           AND A.ORG_ID NOT LIKE '%902'
                           AND A.OPR_STAT IN ('01','08') THEN A.ORG_ID
                  END            AS F_ORG_ID,      --第一个需报送机构
                 ''              AS ORG_BF,        --前置机构
                 ORG_ID          AS ORG_ID,        --本身
                 A.UP_ORG_ID     AS ORG_AFT,       --后置机构（上级机构）
                 A.FIN_PERMIT_NO AS FIN_PERMIT_NO, --金融许可证号
                 A.YBT_FLG       AS YBT_FLG,       --一表通标识
                 CASE WHEN A.FIN_PERMIT_NO IS NOT NULL
                           AND A.ORG_ID NOT LIKE '%902'
                           AND A.OPR_STAT IN ('01','08')
                           AND A.YBT_FLG ='Y' THEN 0
                      ELSE 1 END AS IF_ROLL, --递归标识
                 1               AS LVL            --级别
            FROM RRP_MDL.M_PUM_ORG_INFO A
           WHERE A.DATA_DT='20250930'
          UNION ALL
          SELECT A.ST_ORG_ID     AS ST_ORG_ID,     --初始机构保持不变
                 CASE WHEN A.F_ORG_ID IS NULL
                           AND B.YBT_FLG ='Y'
                           AND B.ORG_ID NOT LIKE '%902'
                           AND B.OPR_STAT IN ('01','08') THEN B.ORG_ID
                      ELSE A.F_ORG_ID
                  END            AS F_ORG_ID,      --第一个需报送机构
                 A.ORG_ID        AS ORG_BF,        --前置机构
                 B.ORG_ID        AS ORG_ID,        --本身
                 B.UP_ORG_ID     AS ORG_AFT,       --后置机构（上级机构）
                 B.FIN_PERMIT_NO AS FIN_PERMIT_NO, --金融许可证号
                 B.YBT_FLG       AS YBT_FLG,       --一表通标识
                 CASE WHEN B.FIN_PERMIT_NO IS NOT NULL
                           AND B.ORG_ID NOT LIKE '%902'
                           AND B.OPR_STAT IN ('01','08')
                           AND B.YBT_FLG ='Y' THEN 0
                      ELSE 1 END AS IF_ROLL, --递归标识
                 LVL+1           AS LVL      --级别
            FROM TMP_ORG_INFO A
           INNER JOIN RRP_MDL.M_PUM_ORG_INFO B
                   ON B.ORG_ID = A.ORG_AFT
                  AND A.IF_ROLL = 1
                  AND A.ORG_ID <> B.ORG_ID
                  AND B.DATA_DT = '20250930'),
  CON_YBT_FLG AS(SELECT --ST_ORG_ID AS ORG_ID,SUBSTR(FIN_PERMIT_NO,1,11)||F_ORG_ID  AS FIN_ORG_NO
                        ST_ORG_ID,F_ORG_ID,ORG_BF,ORG_ID,ORG_AFT,FIN_PERMIT_NO,YBT_FLG,IF_ROLL,LVL,
                        SUBSTR(FIN_PERMIT_NO,1,11)||F_ORG_ID AS FIN_ORG_NO
                   FROM TMP_ORG_INFO WHERE IF_ROLL=0)
  SELECT A.ST_ORG_ID AS ORG_ID,A.F_ORG_ID,SUBSTR(A.FIN_PERMIT_NO,1,11)||A.F_ORG_ID  AS FIN_ORG_NO,B.YBT_FLG
    FROM CON_YBT_FLG A
    LEFT JOIN RRP_MDL.M_PUM_ORG_INFO B
           ON A.ST_ORG_ID = B.ORG_ID
          AND B.DATA_DT = '20250930'
;

