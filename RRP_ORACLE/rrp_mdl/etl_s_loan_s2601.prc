CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_LOAN_S2601(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_S_LOAN_S2601
  *  功能描述：S2601存款结果表
  *  创建日期：20240325
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  S_LOAN_S2601
  *  配置表：  CODE_MAP

      该报表包括以下几个数据来源：各项贷款，担保类，投资理财，贷款承诺等，对应loan_net_VAL并不全部都是贷款净值
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240325   lwb     新增
                2    20250529   lwb     新增贷款承诺数据
                3    20250530   lwb     新增担保类业务及其中：承兑汇票数据
                4    20250704   lwb     '担保类业务'修改S26取数源
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_LOAN_S2601'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_LOAN_S2601'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
  V_STEP := 2;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '插入各项贷款对公部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_LOAN_S2601
    (DATA_DT, --数据日期
     ORG_ID, --机构号
     CUST_ID, --客户号
     RCPT_ID, --借据号
     LOAN_BIZ_TYP, --贷款业务品种
     CUR, --币种
     LOAN_NET_VAL, --贷款净值
     STD_PROD_ID, --标准产品编号
     STD_PROD_NM, --标准产品名称
     LOAN_S26_TYP, --S26业务类型
     DATA_SRC, --数据来源
     REGD_LAND_AREA_CD, --行政区划代码
     LOAN_ACT_DSTR_DT, --贷款放款日期
     LOAN_ORIG_EXP_DT, --贷款到期日期
     LVL5_CL, --五级分类
     PRO_IMPT --减值准备
     )
        SELECT
     V_P_DATE   AS   DATA_DT, --数据日期
     A.ORG_ID   AS ORG_ID, --机构号
     A.CUST_ID  AS CUST_ID, --客户号
     A.RCPT_ID  AS RCPT_ID, --借据号
     A.LOAN_BIZ_TYP as LOAN_BIZ_TYP, --贷款业务品种
     A.CUR     AS CUR, --币种
     A.LOAN_NET_VAL AS LOAN_NET_VAL, --贷款净值
     A.STD_PROD_ID, --标准产品编号
     A.STD_PROD_NM, --标准产品名称
     '各项贷款' as LOAN_S26_TYP, --S26业务类型
     A.DATA_SRC, --数据来源
     FO.REGD_LAND_AREA_CD, --行政区划代码
     A.LOAN_ACT_DSTR_DT, --贷款放款日期
     A.LOAN_ORIG_EXP_DT, --贷款到期日期
     A.LVL5_CL, --五级分类
     NVL(AA.PRO_IMPT,0) --减值准备
            FROM RRP_MDL.S_LOAN A --存款业务整合表
           LEFT JOIN RRP_MDL.M_CUST_CORP_INFO FO
            ON A.CUST_ID = FO.CUST_ID
           AND FO.DATA_DT = V_P_DATE
           LEFT JOIN RRP_MDL.M_OTH_PRO_IMPT_INFO AA
            ON AA.RCPT_ID=A.RCPT_ID
           AND AA.DATA_DT=V_P_DATE
         WHERE A.DATA_DT = V_P_DATE
           AND A.DATA_SRC IN ('对公信贷','票据贴现','票据转贴现')
           AND FO.REGD_LAND_AREA_CD NOT LIKE '44%'
           AND FO.REGD_LAND_AREA_CD NOT LIKE '00%'
       ;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


 /* -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '插入表外业务部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_LOAN_S2601
    (DATA_DT, --数据日期
     ORG_ID, --机构号
     CUST_ID, --客户号
     RCPT_ID, --借据号
     LOAN_BIZ_TYP, --贷款业务品种
     CUR, --币种
     LOAN_NET_VAL, --贷款净值
     STD_PROD_ID, --标准产品编号
     STD_PROD_NM, --标准产品名称
     LOAN_S26_TYP, --S26业务类型
     DATA_SRC, --数据来源
     REGD_LAND_AREA_CD, --行政区划代码
     LOAN_ACT_DSTR_DT, --贷款放款日期
     LOAN_ORIG_EXP_DT, --贷款到期日期
     LVL5_CL, --五级分类
     PRO_IMPT --减值准备
     )
    SELECT
     V_P_DATE as      DATA_DT, --数据日期
     A.ORG_ID, --机构号
     A.CUST_ID, --客户号
     A.RCPT_ID, --借据号
     A.OUT_BIZ_VRTY, --贷款业务品种
     A.CUR, --币种
     A.BAL, --贷款净值
     '' AS STD_PROD_ID, --标准产品编号
     '' AS STD_PROD_NM, --标准产品名称
     '担保类业务' AS LOAN_S26_TYP, --S26业务类型
     A.DATA_SRC, --数据来源
     SUBSTR(AA.REGD_LAND_AREA_CD,0,2)||'0000', --行政区划代码
     '' LOAN_ACT_DSTR_DT, --贷款放款日期
     A.EXP_DT AS LOAN_ORIG_EXP_DT, --贷款到期日期
     A.LVL5_CL, --五级分类
     AAA.PRO_IMPT --减值准备
           FROM RRP_MDL.S_OUT_DUBILL A --表外业务整合表
       LEFT JOIN RRP_MDL.M_CUST_CORP_INFO AA
        ON A.CUST_ID=AA.CUST_ID
        AND SUBSTR(AA.REGD_LAND_AREA_CD,0,2)<>'44'--非广东省
        AND AA.DATA_DT=V_P_DATE
        LEFT JOIN RRP_MDL.M_OTH_PRO_IMPT_INFO AAA
            ON AAA.RCPT_ID=A.RCPT_ID
           AND AAA.DATA_DT=V_P_DATE
     WHERE A.DATA_DT = V_P_DATE
       AND SUBSTR(A.OUT_BIZ_VRTY,0,3) IN ('A01','A02','A03','A04','A05')
               ;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);*/

   
  
   -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '插入贷款承诺部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_LOAN_S2601
    (DATA_DT, --数据日期
     ORG_ID, --机构号
     CUST_ID, --客户号
     RCPT_ID, --借据号
     LOAN_BIZ_TYP, --贷款业务品种
     CUR, --币种
     LOAN_NET_VAL, --贷款净值
     STD_PROD_ID, --标准产品编号
     STD_PROD_NM, --标准产品名称
     LOAN_S26_TYP, --S26业务类型
     DATA_SRC, --数据来源
     REGD_LAND_AREA_CD, --行政区划代码
     LOAN_ACT_DSTR_DT, --贷款放款日期
     LOAN_ORIG_EXP_DT, --贷款到期日期
     LVL5_CL, --五级分类
     PRO_IMPT --减值准备
     )
SELECT   V_P_DATE AS DATA_DT, --数据日期
         SUBSTR(T.MGMT_ORG_NO,0,3)||'001' AS ORG_ID, --机构号
         T.CUST_NO AS CUST_ID, --客户号
         T.CONT_NO AS RCPT_ID, --借据号
     '贷款承诺' AS LOAN_BIZ_TYP, --贷款业务品种
     T.CURR_CD AS CUR, --币种
     T.AVAILABLE_AMT AS LOAN_NET_VAL, --贷款净值  
     T.STD_PROD_NO AS STD_PROD_ID, --标准产品编号
     '贷款承诺' AS STD_PROD_NM, --标准产品名称
     '贷款承诺' AS LOAN_S26_TYP, --S26业务类型
     '贷款承诺' AS DATA_SRC, --数据来源
     T.REGD_LAND_AREA_CD AS REGD_LAND_AREA_CD, --行政区划代码
     TO_CHAR(T.DISTR_DT,'YYYYMMDD') AS LOAN_ACT_DSTR_DT, --贷款放款日期
     TO_CHAR(T.EXP_DT,'YYYYMMDD') AS LOAN_ORIG_EXP_DT, --贷款到期日期
     '01'  AS LVL5_CL, --五级分类
     0  AS PRO_IMPT --减值准备
            FROM RRP_MDL.S_CROP_LOAN_PROMIS T
           WHERE T.DATA_DT = V_P_DATE
             AND T.REGD_LAND_AREA_CD NOT LIKE '44%'
             AND T.REGD_LAND_AREA_CD NOT LIKE '00%'
           UNION ALL
     SELECT V_P_DATE AS DATA_DT, --数据日期
            '893001' AS ORG_ID, --机构号
            T.CUST_ID AS CUST_ID, --客户号
            T.AGT_ID AS RCPT_ID, --借据号
            '贷款承诺' AS LOAN_BIZ_TYP, --贷款业务品种
            T.CURR_CD AS CUR, --币种
            T.OD_LMT AS LOAN_NET_VAL, --贷款净值
            T.LOAN_PROD_ID AS STD_PROD_ID, --标准产品编号
            '贷款承诺' AS STD_PROD_NM, --标准产品名称
            '贷款承诺' AS LOAN_S26_TYP, --S26业务类型
            '贷款承诺' AS DATA_SRC, --数据来源
            TT.REGD_LAND_AREA_CD AS REGD_LAND_AREA_CD, --行政区划代码
            T.EFFECT_DT AS LOAN_ACT_DSTR_DT, --贷款放款日期
            T.INVALID_DT AS LOAN_ORIG_EXP_DT, --贷款到期日期
            '01' AS LVL5_CL, --五级分类
            0 AS PRO_IMPT --减值准备
            FROM RRP_MDL.S_LP_OD_SIGN_H T
           INNER JOIN RRP_MDL.M_CUST_CORP_INFO TT --同业法人透支
              ON TT.CUST_ID = T.CUST_ID
             AND TT.TYBZ = 'Y' --同业标志
             AND TT.REGD_LAND_AREA_CD NOT LIKE '44%'
             AND TT.REGD_LAND_AREA_CD NOT LIKE '00%'
             AND TT.DATA_DT = V_P_DATE
           WHERE T.EFFECT_DT <= V_P_DATE
             AND T.INVALID_DT >= V_P_DATE
             AND T.DATA_DT = V_P_DATE
               ;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   
  
    -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '插入担保类业务及其中：承兑汇票部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_LOAN_S2601
    (DATA_DT, --数据日期
     ORG_ID, --机构号
     CUST_ID, --客户号
     RCPT_ID, --借据号
     LOAN_BIZ_TYP, --贷款业务品种
     CUR, --币种
     LOAN_NET_VAL, --贷款净值
     STD_PROD_ID, --标准产品编号
     STD_PROD_NM, --标准产品名称
     LOAN_S26_TYP, --S26业务类型
     DATA_SRC, --数据来源
     REGD_LAND_AREA_CD, --行政区划代码
     LOAN_ACT_DSTR_DT, --贷款放款日期
     LOAN_ORIG_EXP_DT, --贷款到期日期
     LVL5_CL, --五级分类
     PRO_IMPT --减值准备
     )
 select V_P_DATE AS  DATA_DT, --数据日期
        T.ORG_ID  AS  ORG_ID, --机构号
        T.CUST_ID AS CUST_ID, --客户号
        T.RCPT_ID    AS RCPT_ID, --借据号
        T.OUT_BIZ_VRTY AS LOAN_BIZ_TYP, --贷款业务品种
        T.CUR     AS   CUR, --币种
        T.BAL     AS LOAN_NET_VAL, --贷款净值
     '' STD_PROD_ID, --标准产品编号
     '' STD_PROD_NM, --标准产品名称
     '担保类业务' AS LOAN_S26_TYP, --S26业务类型
     '担保类业务' AS DATA_SRC, --数据来源
     foo.REGD_LAND_AREA_CD AS REGD_LAND_AREA_CD, --行政区划代码
     T.OCCUR_DT AS LOAN_ACT_DSTR_DT, --贷款放款日期
     T.EXP_DT AS LOAN_ORIG_EXP_DT, --贷款到期日期
     T.LVL5_CL AS LVL5_CL, --五级分类
     NVL(AAA.PRO_IMPT,0) AS PRO_IMPT --减值准备
   FROM RRP_MDL.S_OUT_DUBILL T  --T.OUT_BIZ_VRTY=A01 其中：承兑汇票
    LEFT JOIN RRP_MDL.M_CUST_CORP_INFO FOO
            ON t.CUST_ID = FOO.CUST_ID
           AND FOO.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_OTH_PRO_IMPT_INFO AAA
            ON AAA.RCPT_ID=T.RCPT_ID
           AND AAA.DATA_DT=V_P_DATE
WHERE T.DATA_DT=V_P_DATE
    and ((NVL(foo.REGD_LAND_AREA_CD,'000') not like '44%') AND (NVL(foo.REGD_LAND_AREA_CD,'000') not like '00%'))--剔除未知及广东省的数据
    and t.BAL<>0
    AND SUBSTR(T.OUT_BIZ_VRTY,0,3) IN ('A01','A02','A03')
               ;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  

  V_STEP := 5;
  V_STEP_DESC := '表分析';
  V_STARTTIME := SYSDATE;
  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序跑批结束记录 --
  V_STEP := 6;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;

    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_S_LOAN_S2601;
/

