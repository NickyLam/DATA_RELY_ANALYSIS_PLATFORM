CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_SQHS_S6301(I_P_DATE      IN INTEGER,
                                              O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  new
  ***************************************************************************/
 AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_SQHS_S6301'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE; -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'SQHS_S6301'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM SQHS_S6301 T WHERE T.DATA_DT = V_P_DATE;
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE SQHS_S6301

  insert into SQHS_S6301(BGRQ,
SXSQBH,
SQKHH,
SQRQ,
JGBH,
JGMC,
SQKHMC,
SQKHQYGM,
SQKHEDLX,
SQZXCPMC,
FSLX,
FKRQ,
SFQY
)
SELECT BGRQ     AS "报告日期"
      ,SXSQBH   AS "授信申请编号"
      ,SQKHWYM  AS "申请客户号"
      ,SQRQ     AS "申请日期"
      ,ZWJGBH   AS "机构编号"
      ,ZWJGMC   AS "机构名称"
      ,SQKHMC   AS "申请客户名称"
      ,CASE WHEN SQKHQYGM NOT IN  ('大型','中型','小型','微型')OR SQKHQYGM IS NULL THEN '中型' ELSE SQKHQYGM END AS "申请客户企业规模"
     --  ,DECODE(SQKHQYGM,'大型','L','中型','M','小型','S','微型','X','其他对公客户','Z') AS "申请客户企业规模"
      ,CASE WHEN SQKHEDLX IS NOT NULL THEN SQKHEDLX
            WHEN T4.PROD_NAME IS NOT NULL THEN T4.PROD_NAME
            ELSE T2.STD_PROD_ID
            END  AS "申请客户额度类型"
      ,SQZXED   AS "申请专项产品名称"
      ,CASE WHEN T1.FSLX IS NOT NULL THEN T1.FSLX
            WHEN NVL(T3.LOAN_HAPP_TYPE_CD,T5.HAPP_TYPE_CD) = '0100' THEN '新增'
            WHEN NVL(T3.LOAN_HAPP_TYPE_CD,T5.HAPP_TYPE_CD) = '0101' THEN '授信条件变更'
            WHEN NVL(T3.LOAN_HAPP_TYPE_CD,T5.HAPP_TYPE_CD) = '0102' THEN '原额度续作'
            WHEN NVL(T3.LOAN_HAPP_TYPE_CD,T5.HAPP_TYPE_CD) = '0103' THEN '增额续作'
            WHEN NVL(T3.LOAN_HAPP_TYPE_CD,T5.HAPP_TYPE_CD) = '0104' THEN '减额续作'
            WHEN NVL(T3.LOAN_HAPP_TYPE_CD,T5.HAPP_TYPE_CD) = '0201' THEN '展期'
            WHEN NVL(T3.LOAN_HAPP_TYPE_CD,T5.HAPP_TYPE_CD) = '0202' THEN '借新还旧'
            WHEN NVL(T3.LOAN_HAPP_TYPE_CD,T5.HAPP_TYPE_CD) = '0204' THEN '债务重组'
            WHEN NVL(T3.LOAN_HAPP_TYPE_CD,T5.HAPP_TYPE_CD) = '0205' THEN '新借'
            WHEN NVL(T3.LOAN_HAPP_TYPE_CD,T5.HAPP_TYPE_CD) = '0206' THEN '复议'
            WHEN NVL(T3.LOAN_HAPP_TYPE_CD,T5.HAPP_TYPE_CD) = '0207' THEN '年审'
            WHEN NVL(T3.LOAN_HAPP_TYPE_CD,T5.HAPP_TYPE_CD) = '0208' THEN '变更借款人'
           END AS "发生类型（授信申请）"
      ,CASE WHEN T2.DISTR_DT = DATE '0001-01-01' THEN NULL ELSE TO_CHAR(T2.DISTR_DT,'YYYYMMDD')
           END AS "放款日期"
      ,CASE WHEN CORP.CBRC_CUST_CL IN ('企业','农村集体经济组织（企业）','农民专业合作社（企业）' )
       THEN 'Y' ELSE 'N' END AS 是否企业
FROM RRP_MDL.A_FGB_APPLY T1
LEFT JOIN RRP_MDL.M_CUST_CORP_INFO CORP --对公客户信息
            ON CORP.CUST_ID = T1.SQKHWYM
          AND CORP.DATA_DT = V_P_DATE
LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T2
ON T1.SXSQBH = T2.DUBIL_ID
AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO T3
ON T2.CONT_ID = T3.CONT_ID
AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO T4
ON T2.STD_PROD_ID = T4.PROD_ID
AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_APPL_INFO T5
ON T1.SXSQBH = T5.LOAN_APPL_FLOW_NUM
AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
WHERE T1.BGRQ = V_P_DATE
   AND SUBSTR(SQRQ,1,6) =  SUBSTR( V_P_DATE,1,6)
union all
SELECT T1.data_dt     AS "报告日期"
      ,''   AS "授信申请编号"
      ,T1.CUST_ID  AS "申请客户号"
      ,T1.LOAN_ACT_DSTR_DT     AS "申请日期"
      ,T1.ORG_ID   AS "机构编号"
      ,''   AS "机构名称"
      ,b.CUST_NM   AS "申请客户名称"
      ,CASE WHEN (B.ENT_SCALE NOT IN ('L','M','S','X')OR B.ENT_SCALE IS NULL) --AND  T1.DATA_SRC  IN ('票据转贴现')
            THEN '中型'
        else DECODE(B.ENT_SCALE,'L','大型','M','中型','S','小型','X','微型','Z','其他对公客户')   END  AS "申请客户企业规模"
      ,''  AS "申请客户额度类型"
      ,''   AS "申请专项产品名称"
      ,'' AS "发生类型（授信申请）"
      ,T1.LOAN_ACT_DSTR_DT AS "放款日期"
      ,T1.IS_CBRC_ENT 是否企业
 FROM RRP_MDL.S_LOAN T1
   LEFT JOIN RRP_MDL.M_CUST_CORP_INFO B --对公客户信息
                                           ON B.CUST_ID = T1.CUST_ID
                                          AND B.DATA_DT = V_P_DATE
                                        --  AND B.CBRC_CUST_CL IN ('企业','农村集体经济组织（企业）','农民专业合作社（企业）' )
                                        WHERE T1.DATA_DT =  V_P_DATE
                                          AND T1.DATA_SRC IN ('对公信贷','票据贴现','票据转贴现')
                                          AND SUBSTR(T1.LOAN_ACT_DSTR_DT,1,6) =  SUBSTR( V_P_DATE,1,6)
                                          ;
  V_SQLCOUNT    := SQL%ROWCOUNT;
  V_SQLMSG      := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME     := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,
                V_SYSTEM,
                V_PROC_NAME,
                V_STARTTIME,
                V_ENDTIME,
                V_STEP,
                V_STEP_DESC,
                V_SQLCOUNT,
                O_ERRCODE,
                V_SQLMSG);








  -- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME     := SYSDATE;
    V_STEP        := V_STEP + 1;
    V_STEP_DESC   := '-- 程序跑批异常 --';
    ETL_YUSYS_LOG(V_P_DATE,
                  V_SYSTEM,
                  V_PROC_NAME,
                  V_STARTTIME,
                  V_ENDTIME,
                  V_STEP,
                  V_STEP_DESC,
                  V_SQLCOUNT,
                  O_ERRCODE,
                  V_SQLMSG);

END ETL_SQHS_S6301;
/

