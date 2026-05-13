CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_LOAN_AGR_REL_SUB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_LOAN_AGR_REL_SUB
  *  功能描述：涉农贷款子表
  *  创建日期：20220523
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_LOAN_AGR_REL_SUB
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220523  梅炜      首次创建
  *             2    20221111  于敬艺    添加AGCLT_LOAN_MAIN_TYPE_CD  涉农贷款主体类型代码
  *             3    20221114   hulj     增加数据重复校验
  *             4    20221128   mw       增加联合网贷口径
                5    20240306   lwb      增加网商贷非农户涉农贷款的口径，1012880707客户号默认为非农户
                6    20240426   LWB      1201235888客户号默认20240331之前的数据为非农户 （放款时农户标识）
                7    20240819   lwb      针对业务修改放款时农户标志的场景修改逻辑，仅针对零售和联合网贷
                8    20250226   YJY      默认微粒贷业务（经营和消费）“农户标志”均为否
                9    20250521   YJY      修改联合网贷部分的借据号，取核心借据编号
                9    20250606   LWB      增加字节小微贷款的涉农部分
                10   20250618   HYF      调整联合网贷部分逻辑，改为关联CODE_MAP 
                11   20250725   YJY      回退联合网贷部分的借据号
                12   20251111   YJY      修改担保类型的映射
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;            --处理步骤
  V_P_DATE    VARCHAR2(8);             --跑批数据日期
  V_STARTTIME DATE;                    --处理开始时间
  V_ENDTIME   DATE;                    --处理结束时间
  V_SQLCOUNT  INTEGER := 0;            --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);           --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);           --任务名称
  V_PART_NAME VARCHAR2(100);           --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_LOAN_AGR_REL_SUB'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_LOAN_AGR_REL_SUB'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统  --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_LOAN_AGR_REL_SUB T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_LOAN_AGR_REL_SUB'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,'1',O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2;
  V_STEP_DESC := '插入涉农贷款子表-对公';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_AGR_REL_SUB
    (DATA_DT                      --数据日期
    ,LGL_REP_ID                   --法人编号
    ,ORG_ID                       --机构编号
    ,RCPT_ID                      --借据编号
    ,AGR_REL_LOAN_BIZ_TYP         --涉农贷款业务类型
    ,AGR_CPRSV_DVLP_LOAN_FLG      --农业综合开发贷款标志
    ,LOAN_CHAR                    --贷款性质
    ,FARMER_COOP_LOAN_FLG         --农民合作社贷款标志
    ,VIL_THREE_RT_MTG_LOAN_CL     --农村三权抵押贷款分类
    ,VIL_COLLTV_ECON_ORG_LOAN_FLG --农村集体经济组织贷款标志
    ,FARM_LOAN_FLG                --农户贷款标志
    ,TWO_RT_LOAN_GUA_MODE         --两权贷款担保方式
    ,FAMILY_FARM_LOAN_FLG         --家庭农场贷款标识
    ,DEPT_LINE                    --部门条线
    ,DATA_SRC                     --数据来源
    ,AGCLT_LOAN_MAIN_TYPE_CD      --涉农贷款主体类型代码 A1333使用 MODIFY BY 于敬艺 IN20221111
    )
  SELECT V_P_DATE                               AS DATA_DT                      --数据日期
        ,A.LP_ID                                AS LGL_REP_ID                   --法人编号
        ,A.ORG_ID                               AS ORG_ID                       --机构编号
        ,A.DUBIL_ID                             AS RCPT_ID                      --借据编号
        ,CASE WHEN B.AGCLT_LOAN_DIR_CD = '01' THEN 'A'
              WHEN B.AGCLT_LOAN_DIR_CD = '0201' THEN 'B01'
              WHEN B.AGCLT_LOAN_DIR_CD = '0202' THEN 'B02'
              WHEN B.AGCLT_LOAN_DIR_CD = '0203' THEN 'B03'
              WHEN B.AGCLT_LOAN_DIR_CD = '0204' THEN 'B04'
              WHEN B.AGCLT_LOAN_DIR_CD = '0205' THEN 'B05'
              WHEN B.AGCLT_LOAN_DIR_CD = '0206' THEN 'B06'
              ELSE 'Z'
          END                                   AS AGR_REL_LOAN_BIZ_TYP         --涉农贷款业务类型
        ,'Y'                                    AS AGR_CPRSV_DVLP_LOAN_FLG      --农业综合开发贷款标志
        ,'2'                                    AS LOAN_CHAR                    --贷款性质
        ,CASE WHEN TY.FIN_INST_CATE_CD IN ('1C2000','1C3000') THEN 'Y'
              ELSE 'N'
          END                                   AS FARMER_COOP_LOAN_FLG         --农民合作社贷款标志
        /*,CASE WHEN B.GUAR_TYPE_CD LIKE 'DY0302%' THEN '1'
              WHEN B.GUAR_TYPE_CD LIKE 'DY0201%' THEN '2'
              WHEN B.GUAR_TYPE_CD LIKE 'ZY0603006' THEN '3'
              ELSE NULL
          END*/--MOD BY YJY 20251111 修改担保类型的的映射
        ,CASE WHEN B.GUAR_TYPE_CD = '80040010020' THEN '1'
              WHEN B.GUAR_TYPE_CD IN ('80010010010','80010010020','80010010030'
                                      ,'80010010040','80010010060','80010010070') THEN '2'
              WHEN B.GUAR_TYPE_CD = '90040030010' THEN '3'
              ELSE NULL
          END                                  AS VIL_THREE_RT_MTG_LOAN_CL     --农村三权抵押贷款分类  
        ,CASE WHEN C.CRDT_CUST_TYPE_CD IN ('0210','04') THEN 'Y'
              ELSE 'N'
          END                                   AS VIL_COLLTV_ECON_ORG_LOAN_FLG --农村集体经济组织贷款标志
        ,CASE WHEN D.FARM_FLG = '1' THEN 'Y'
              ELSE 'N'
          END                                   AS FARM_LOAN_FLG                --农户贷款标志
        /*,CASE WHEN B.GUAR_TYPE_CD LIKE 'DY0302%' THEN 'A'
              WHEN B.GUAR_TYPE_CD LIKE 'DY0201%' THEN 'B'
              ELSE 'C'
          END*/--MOD BY YJY 20251111 修改担保类型的的映射
        ,CASE WHEN B.GUAR_TYPE_CD = '80040010020' THEN 'A'
              WHEN B.GUAR_TYPE_CD IN ('80010010010','80010010020','80010010030'
                                      ,'80010010040','80010010060','80010010070') THEN 'B'
              ELSE 'C'
          END                                   AS TWO_RT_LOAN_GUA_MODE         --两权贷款担保方式
        ,'N'                                    AS FAMILY_FARM_LOAN_FLG         --家庭农场贷款标识  --上游暂无标识
        ,'800919'                               AS DEPT_LINE                    --部门条线
        ,'涉农-对公'                            AS DATA_SRC                     --数据来源
        ,B.AGCLT_LOAN_MAIN_TYPE_CD              AS AGCLT_LOAN_MAIN_TYPE_CD      --涉农贷款主体类型代码（N12:农村企业贷款  N13:农村各类组织贷款  N22城市企业涉农贷款  N23城市各类组织涉农贷款）
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A --对公贷款借据信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO B --对公贷款合同信息
      ON B.CONT_ID = A.CONT_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO C --对公客户基本信息
      ON C.CUST_ID = A.CUST_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO D --个人客户基本信息
      ON D.CUST_ID = A.CUST_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_IBANK_CUST_CHAT_INFO TY --同业客户特有信息
      ON TY.PARTY_ID = NVL(C.LP_ORG_CUST_ID,C.CUST_ID)
     AND TY.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TY.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE B.AGCLT_FLG = '1'
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 3;
  V_STEP_DESC := '插入涉农贷款子表-个人';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_AGR_REL_SUB
    (DATA_DT                      --数据日期
    ,LGL_REP_ID                   --法人编号
    ,ORG_ID                       --机构编号
    ,RCPT_ID                      --借据编号
    ,AGR_REL_LOAN_BIZ_TYP         --涉农贷款业务类型
    ,AGR_CPRSV_DVLP_LOAN_FLG      --农业综合开发贷款标志
    ,LOAN_CHAR                    --贷款性质
    ,FARMER_COOP_LOAN_FLG         --农民合作社贷款标志
    ,VIL_THREE_RT_MTG_LOAN_CL     --农村三权抵押贷款分类
    ,VIL_COLLTV_ECON_ORG_LOAN_FLG --农村集体经济组织贷款标志
    ,FARM_LOAN_FLG                --农户贷款标志
    ,TWO_RT_LOAN_GUA_MODE         --两权贷款担保方式
    ,FAMILY_FARM_LOAN_FLG         --家庭农场贷款标识
    ,DEPT_LINE                    --部门条线
    ,DATA_SRC                     --数据来源
    ,AGCLT_LOAN_MAIN_TYPE_CD      --涉农贷款主体类型代码 A1333使用 MODIFY BY 于敬艺 IN20221111
    )
  SELECT V_P_DATE                               AS DATA_DT                      --数据日期
        ,A.LP_ID                                AS LGL_REP_ID                   --法人编号
        ,NVL(A.RGST_ORG_ID,A.MGMT_ORG_ID)       AS ORG_ID                       --机构编号
        ,A.DUBIL_ID                             AS RCPT_ID                      --借据编号
        ,CASE WHEN B.DIR_INDUS_CD LIKE 'A%' THEN 'A'
              ELSE 'Z'
          END                                   AS AGR_REL_LOAN_BIZ_TYP         --涉农贷款业务类型
        ,'N'                                    AS AGR_CPRSV_DVLP_LOAN_FLG      --农业综合开发贷款标志
        ,'1'                                    AS LOAN_CHAR                    --贷款性质
        ,'N'                                    AS FARMER_COOP_LOAN_FLG         --农民合作社贷款标志
        ,NULL                                   AS VIL_THREE_RT_MTG_LOAN_CL     --农村三权抵押贷款分类
        ,'N'                                    AS VIL_COLLTV_ECON_ORG_LOAN_FLG --农村集体经济组织贷款标志
        ,CASE WHEN D.FARM_FLG = '1' THEN 'Y'
              ELSE 'N'
          END                                   AS FARM_LOAN_FLG                --农户贷款标志
        ,'C'                                    AS TWO_RT_LOAN_GUA_MODE         --两权贷款担保方式
        ,'N'                                    AS FAMILY_FARM_LOAN_FLG         --家庭农场贷款标识 --上游暂无标识
        ,'800919'                               AS DEPT_LINE                    --部门条线
        ,'涉农-零售'                            AS DATA_SRC                     --数据来源
        ,NULL                                   AS AGCLT_LOAN_MAIN_TYPE_CD      --涉农贷款主体类型代码 A1333使用 MODIFY BY 于敬艺 IN20221111
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO A --零售贷款借据信息
   INNER JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO AA
      ON AA.DUBIL_NUM = A.DUBIL_ID
     AND AA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO B --零售贷款合同信息
      ON B.CONT_ID = A.CONT_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN ICL.V_CMM_INDV_CUST_BASIC_INFO D --个人客户基本信息
      ON D.CUST_ID = A.CUST_ID
     AND D.ETL_DT = (CASE WHEN AA.DISTR_DT >= TO_DATE('20231231','YYYYMMDD')
                          THEN ADD_MONTHS(TRUNC(AA.DISTR_DT,'MM')-1,1)
                          ELSE TO_DATE('20231231','YYYYMMDD')
                      END)
    LEFT JOIN RRP_MDL.CODE_MAP TTA
      ON TTA.SRC_VALUE_CODE = A.STD_PROD_ID
     AND TTA.SRC_CLASS_CODE = 'STD0002'
     AND TTA.TAR_CLASS_CODE = 'T0001'
     AND TTA.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.M_LOAN_AGR_REL_SUB_CONFIG AAA
      ON AAA.RCPT_ID = A.DUBIL_ID
     AND AAA.ZSBZ = 'I'
   WHERE ((B.DIR_INDUS_CD LIKE 'A%' AND TTA.TAR_VALUE_CODE LIKE '0102%')  --是农林牧渔业的  20102% --个人经营性贷款
          OR (B.DIR_INDUS_CD LIKE 'C13%' AND TTA.TAR_VALUE_CODE LIKE '0102%') --是农副食品加工业的  20102% --个人经营性贷款
          OR (D.FARM_FLG = '1' AND D.CUST_ID NOT IN ('1012880707','1201235888') --涉农子表修改
              OR (D.CUST_ID = '1201235888' AND D.FARM_FLG = '1' AND AA.DISTR_DT > TO_DATE('20240331','YYYYMMDD'))) --是农户的
          OR ( TTA.TAR_VALUE_CODE LIKE '0102%'
              AND (SUBSTR(B.DIR_INDUS_CD,1,4) IN ('C201','C204','C262','C263','C357','F511','G595')
                  OR SUBSTR(B.DIR_INDUS_CD,1,5) IN ('C1711','C1712','C1713','C1731','C1732','C1741',
                                                    'C1742','C2730','C2740','C2921','C3323','C4024',
                                                    'F5121','F5123','F5124','F5152','F5166','F5167',
                                                    'F5168','F5171','F5221','F5223','F5224','F5252',
                                                    'M7330','M7511','M7530')))
                  OR (AAA.RCPT_ID = A.DUBIL_ID)) --MODIFY BY LWB 20240819
     AND NOT EXISTS (SELECT 1 FROM RRP_MDL.M_LOAN_AGR_REL_SUB_CONFIG CONFIG
                      WHERE CONFIG.ZSBZ = 'D' AND CONFIG.RCPT_ID = A.DUBIL_ID)--MODIFY BY LWB 20240819 删除数据
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 3;
  V_STEP_DESC := '插入涉农贷款子表-联合网贷';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_AGR_REL_SUB
    (DATA_DT                      --数据日期
    ,LGL_REP_ID                   --法人编号
    ,ORG_ID                       --机构编号
    ,RCPT_ID                      --借据编号
    ,AGR_REL_LOAN_BIZ_TYP         --涉农贷款业务类型
    ,AGR_CPRSV_DVLP_LOAN_FLG      --农业综合开发贷款标志
    ,LOAN_CHAR                    --贷款性质
    ,FARMER_COOP_LOAN_FLG         --农民合作社贷款标志
    ,VIL_THREE_RT_MTG_LOAN_CL     --农村三权抵押贷款分类
    ,VIL_COLLTV_ECON_ORG_LOAN_FLG --农村集体经济组织贷款标志
    ,FARM_LOAN_FLG                --农户贷款标志
    ,TWO_RT_LOAN_GUA_MODE         --两权贷款担保方式
    ,FAMILY_FARM_LOAN_FLG         --家庭农场贷款标识
    ,DEPT_LINE                    --部门条线
    ,DATA_SRC                     --数据来源
    ,AGCLT_LOAN_MAIN_TYPE_CD      --涉农贷款主体类型代码 A1333使用 MODIFY BY 于敬艺 IN20221111
    )
  SELECT V_P_DATE                               AS DATA_DT                      --数据日期
        ,T1.LP_ID                               AS LGL_REP_ID                   --法人编号
        ,T1.ACCT_INSTIT_ID                      AS ORG_ID                       --机构编号
        /*,T1.DUBIL_ID                            AS RCPT_ID                      --借据编号*/
        /*,T1.CORE_DUBIL_ID                       AS RCPT_ID                      --借据编号 MOD BY YJY 20250521 取联合网贷的核心借据号 */
        ,T1.DUBIL_ID                            AS RCPT_ID                      --借据编号 mod by yjy 20250725
        ,CASE WHEN T1.DIR_INDUS_CD LIKE 'A%' THEN 'A'
              ELSE 'Z'
          END                                   AS AGR_REL_LOAN_BIZ_TYP         --涉农贷款业务类型
        ,'N'                                    AS AGR_CPRSV_DVLP_LOAN_FLG      --农业综合开发贷款标志
        ,'1'                                    AS LOAN_CHAR                    --贷款性质
        ,'N'                                    AS FARMER_COOP_LOAN_FLG         --农民合作社贷款标志
        ,NULL                                   AS VIL_THREE_RT_MTG_LOAN_CL     --农村三权抵押贷款分类
        ,'N'                                    AS VIL_COLLTV_ECON_ORG_LOAN_FLG --农村集体经济组织贷款标志
        ,CASE WHEN T1.STD_PROD_ID IN ( '202010100006','202010100008','202020100003')
              THEN 'N' --MOD BY YJY 20250226  默认微粒贷业务（经营和消费）“农户标志”均为否
              WHEN T2.FARM_FLG = '1' THEN 'Y'
              ELSE 'N'
          END                                   AS FARM_LOAN_FLG                --农户贷款标志  
        ,'C'                                    AS TWO_RT_LOAN_GUA_MODE         --两权贷款担保方式
        ,'N'                                    AS FAMILY_FARM_LOAN_FLG         --家庭农场贷款标识 --上游暂无标识
        ,NULL                                   AS DEPT_LINE                    --部门条线
        ,'涉农-联合网贷'                        AS DATA_SRC                     --数据来源
        ,NULL                                   AS AGCLT_LOAN_MAIN_TYPE_CD      --涉农贷款主体类型代码 A1333使用 MODIFY BY 于敬艺 IN20221111
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO T1 --联合网贷借据信息
    LEFT JOIN ICL.V_CMM_INDV_CUST_BASIC_INFO T2 --个人客户基本信息
      ON T2.CUST_ID = T1.CUST_ID
     AND T2.ETL_DT = (CASE WHEN T1.DISTR_DT >= TO_DATE('20231231','YYYYMMDD')
                           THEN ADD_MONTHS(TRUNC(T1.DISTR_DT,'MM')-1,1)
                           ELSE TO_DATE('20231231','YYYYMMDD')
                       END)--MODIFY BY LWB 以20231231为界限，之后的数据取放款日当月月末的客户信息，之前的直取20231231的客户标识
     LEFT JOIN RRP_MDL.CODE_MAP TTA   --mod by hyf 20250618
      ON TTA.SRC_VALUE_CODE = T1.STD_PROD_ID
     AND TTA.SRC_CLASS_CODE = 'STD0002'
     AND TTA.TAR_CLASS_CODE = 'T0001'
     AND TTA.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.M_LOAN_AGR_REL_SUB_CONFIG AAA
      ON AAA.RCPT_ID = T1.DUBIL_ID
     AND AAA.ZSBZ = 'I'                   
   WHERE ((T1.DIR_INDUS_CD LIKE 'A%' AND TTA.TAR_VALUE_CODE LIKE '0102%')  --是农林牧渔业的  --个人经营性贷款
          OR (T1.DIR_INDUS_CD LIKE 'C13%' AND TTA.TAR_VALUE_CODE LIKE '0102%') --是农副食品加工业的  20102% --个人经营性贷款
          OR (T2.FARM_FLG = '1' AND T2.CUST_ID NOT IN ('1012880707','1201235888') --涉农子表修改
              OR (T2.CUST_ID = '1201235888' AND T2.FARM_FLG = '1' AND T1.DISTR_DT > TO_DATE('20240331','YYYYMMDD'))) --是农户的
          OR (TTA.TAR_VALUE_CODE LIKE '0102%'
               AND (SUBSTR(T1.DIR_INDUS_CD,1,4) IN ('C201','C204','C262','C263','C357','F511','G595')
                    OR SUBSTR(T1.DIR_INDUS_CD,1,5) IN ('C1711','C1712','C1713','C1731','C1732','C1741',
                                                       'C1742','C2730','C2740','C2921','C3323','C4024',
                                                       'F5121','F5123','F5124','F5152','F5166','F5167',
                                                       'F5168','F5171','F5221','F5223','F5224','F5252',
                                                       'M7330','M7511','M7530')))
                    OR (AAA.RCPT_ID = T1.DUBIL_ID))--MODIFY BY LWB 20240819 增加数据
     AND NOT EXISTS (SELECT 1 FROM RRP_MDL.M_LOAN_AGR_REL_SUB_CONFIG CONFIG
                      WHERE CONFIG.ZSBZ = 'D' AND CONFIG.RCPT_ID = T1.DUBIL_ID)--MODIFY BY LWB 20240819 删除数据
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
  WITH TMP1 AS (
    SELECT DATA_DT, RCPT_ID,COUNT(1)
      FROM RRP_MDL.M_LOAN_AGR_REL_SUB T
     WHERE DATA_DT = V_P_DATE
     GROUP BY DATA_DT, RCPT_ID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '--程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  --插入过程跑批完成记录表
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_LOAN_AGR_REL_SUB;
/

