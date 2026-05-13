CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_LOAN_AGR_REL_SUB(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_LOAN_AGR_REL_SUB
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
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_LOAN_AGR_REL_SUB'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_LAST_DAT  VARCHAR2(8); -- 当月月末
  V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_LOAN_AGR_REL_SUB'; --表名
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

  --判断跑批频度--


  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;

  --初始化表增加分区
  V_STEP_DESC := '初始化表增加分区';
  V_START_DT := SUBSTR(V_P_DATE,0,6)||'01';
  WHILE TO_DATE(V_START_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
  LOOP
  ETL_PARTITION_ADD(V_START_DT,V_TAB_NAME, '1', O_ERRCODE);
  V_START_DT := TO_CHAR(TO_DATE(V_START_DT,'YYYYMMDD')  + 1 ,'YYYYMMDD');
  END LOOP;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入涉农贷款子表-对公';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_AGR_REL_SUB
  (
      DATA_DT  --数据日期
      ,LGL_REP_ID  --法人编号
      ,ORG_ID  --机构编号
      ,RCPT_ID  --借据编号
      ,AGR_REL_LOAN_BIZ_TYP  --涉农贷款业务类型
      ,AGR_CPRSV_DVLP_LOAN_FLG  --农业综合开发贷款标志
      ,LOAN_CHAR  --贷款性质
      ,FARMER_COOP_LOAN_FLG  --农民合作社贷款标志
      ,VIL_THREE_RT_MTG_LOAN_CL  --农村三权抵押贷款分类
      ,VIL_COLLTV_ECON_ORG_LOAN_FLG  --农村集体经济组织贷款标志
      ,FARM_LOAN_FLG  --农户贷款标志
      ,TWO_RT_LOAN_GUA_MODE  --两权贷款担保方式
      ,FAMILY_FARM_LOAN_FLG  --家庭农场贷款标识
      ,DEPT_LINE  --部门条线
      ,DATA_SRC  --数据来源
      ,AGCLT_LOAN_MAIN_TYPE_CD   --涉农贷款主体类型代码  A1333使用     modify by 于敬艺 in20221111
  )
  SELECT
      V_P_DATE               DATA_DT  --数据日期
      ,A.LP_ID               LGL_REP_ID  --法人编号
      ,A.ORG_ID               ORG_ID  --机构编号
      ,A.DUBIL_ID            RCPT_ID  --借据编号
      ,CASE WHEN B.AGCLT_LOAN_DIR_CD = '01'  THEN 'A'
            WHEN B.AGCLT_LOAN_DIR_CD = '0201' THEN 'B01'
            WHEN B.AGCLT_LOAN_DIR_CD = '0202' THEN 'B02'
            WHEN B.AGCLT_LOAN_DIR_CD = '0203' THEN 'B03'
            WHEN B.AGCLT_LOAN_DIR_CD = '0204' THEN 'B04'
            WHEN B.AGCLT_LOAN_DIR_CD = '0205' THEN 'B05'
            WHEN B.AGCLT_LOAN_DIR_CD = '0206' THEN 'B06'
            ELSE 'Z'
       END                       AGR_REL_LOAN_BIZ_TYP  --涉农贷款业务类型
      ,'Y'                       AGR_CPRSV_DVLP_LOAN_FLG  --农业综合开发贷款标志
      ,'2'                      LOAN_CHAR  --贷款性质
      ,CASE WHEN TY.FIN_INST_CATE_CD IN ('1C2000','1C3000') THEN 'Y'
            ELSE 'N'
       END    FARMER_COOP_LOAN_FLG  --农民合作社贷款标志
      ,CASE WHEN B.GUAR_TYPE_CD LIKE 'DY0302%'  THEN '1'
            WHEN B.GUAR_TYPE_CD LIKE 'DY0201%' THEN '2'
            WHEN B.GUAR_TYPE_CD LIKE 'ZY0603006' THEN '3'
            ELSE NULL
            END                  VIL_THREE_RT_MTG_LOAN_CL  --农村三权抵押贷款分类
      ,CASE WHEN C.CRDT_CUST_TYPE_CD IN ('0210','04') THEN 'Y'
            ELSE 'N'
       END   VIL_COLLTV_ECON_ORG_LOAN_FLG  --农村集体经济组织贷款标志
      ,CASE WHEN D.FARM_FLG = '1'THEN 'Y'
            ELSE'N'
            END   FARM_LOAN_FLG  --农户贷款标志
      ,CASE WHEN B.GUAR_TYPE_CD LIKE 'DY0302%'  THEN 'A'
            WHEN B.GUAR_TYPE_CD LIKE 'DY0201%' THEN 'B'
            ELSE 'C'
            END   TWO_RT_LOAN_GUA_MODE  --两权贷款担保方式
      ,'N'       FAMILY_FARM_LOAN_FLG  --家庭农场贷款标识  --上游暂无标识
      ,'800919'DEPT_LINE  --部门条线
      ,'涉农-对公' DATA_SRC  --数据来源
      ,B.AGCLT_LOAN_MAIN_TYPE_CD  AS AGCLT_LOAN_MAIN_TYPE_CD  --涉农贷款主体类型代码（N12:农村企业贷款  N13:农村各类组织贷款  N22城市企业涉农贷款  N23城市各类组织涉农贷款）
   FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A  --对公贷款借据信息
   LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO B --对公贷款合同信息
        ON A.CONT_ID = B.CONT_ID
        AND B.ETL_DT = A.ETL_DT
   LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO C --对公客户基本信息
        ON C.CUST_ID = A.CUST_ID
        AND C.ETL_DT = A.ETL_DT
   LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO D --个人客户基本信息
        ON A.CUST_ID = D.CUST_ID
        AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_IML_PTY_IBANK_CUST_CHAT_INFO TY --同业客户特有信息
  ON NVL(C.LP_ORG_CUST_ID,C.CUST_ID)=TY.PARTY_ID
  AND C.ETL_DT>=TY.START_DT
  AND C.ETL_DT<TY.END_DT
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   AND B.AGCLT_FLG ='1';
   --AND B.AGCLT_FLG <> '0'

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


   V_STEP := 3; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入涉农贷款子表-个人';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_AGR_REL_SUB
  (
      DATA_DT  --数据日期
      ,LGL_REP_ID  --法人编号
      ,ORG_ID  --机构编号
      ,RCPT_ID  --借据编号
      ,AGR_REL_LOAN_BIZ_TYP  --涉农贷款业务类型
      ,AGR_CPRSV_DVLP_LOAN_FLG  --农业综合开发贷款标志
      ,LOAN_CHAR  --贷款性质
      ,FARMER_COOP_LOAN_FLG  --农民合作社贷款标志
      ,VIL_THREE_RT_MTG_LOAN_CL  --农村三权抵押贷款分类
      ,VIL_COLLTV_ECON_ORG_LOAN_FLG  --农村集体经济组织贷款标志
      ,FARM_LOAN_FLG  --农户贷款标志
      ,TWO_RT_LOAN_GUA_MODE  --两权贷款担保方式
      ,FAMILY_FARM_LOAN_FLG  --家庭农场贷款标识
      ,DEPT_LINE  --部门条线
      ,DATA_SRC  --数据来源
      ,AGCLT_LOAN_MAIN_TYPE_CD   --涉农贷款主体类型代码  A1333使用     modify by 于敬艺 in20221111
  )
  SELECT
      V_P_DATE               DATA_DT  --数据日期
      ,A.LP_ID               LGL_REP_ID  --法人编号
      ,NVL(A.RGST_ORG_ID,A.MGMT_ORG_ID)           ORG_ID  --机构编号
      ,A.DUBIL_ID            RCPT_ID  --借据编号
      ,CASE WHEN B.DIR_INDUS_CD LIKE 'A%'  THEN 'A'
            ELSE 'Z'
       END                       AGR_REL_LOAN_BIZ_TYP  --涉农贷款业务类型
      ,'N'                       AGR_CPRSV_DVLP_LOAN_FLG  --农业综合开发贷款标志
      ,'1'                      LOAN_CHAR  --贷款性质
      ,'N' FARMER_COOP_LOAN_FLG  --农民合作社贷款标志
      ,NULL                  VIL_THREE_RT_MTG_LOAN_CL  --农村三权抵押贷款分类
      ,'N' VIL_COLLTV_ECON_ORG_LOAN_FLG  --农村集体经济组织贷款标志
      ,CASE WHEN D.FARM_FLG = '1'THEN 'Y'
            ELSE'N'
            END  FARM_LOAN_FLG  --农户贷款标志
      ,'C'   TWO_RT_LOAN_GUA_MODE  --两权贷款担保方式
      ,'N'   FAMILY_FARM_LOAN_FLG  --家庭农场贷款标识        ----上游暂无标识
      ,'800919' DEPT_LINE  --部门条线
      ,'涉农-零售' DATA_SRC  --数据来源
      ,NULL   --涉农贷款主体类型代码  A1333使用     modify by 于敬艺 in20221111
   FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO A  --零售贷款借据信息
   LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO B --零售贷款合同信息
        ON B.CONT_ID = A.CONT_ID
        AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO D --个人客户基本信息
        ON A.CUST_ID = D.CUST_ID
        AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN CODE_MAP TTA
        ON TTA.SRC_VALUE_CODE = A.STD_PROD_ID
        AND TTA.SRC_CLASS_CODE = 'STD0002'
        AND TTA.TAR_CLASS_CODE = 'T0001'
        AND TTA.MOD_FLG = 'MDM'
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   AND  (( B.DIR_INDUS_CD LIKE 'A%' AND TTA.TAR_VALUE_CODE LIKE '0102%' )  --是农林牧渔业的  20102% --个人经营性贷款
           OR (B.DIR_INDUS_CD LIKE 'C13%' AND TTA.TAR_VALUE_CODE LIKE '0102%') --是农副食品加工业的  20102% --个人经营性贷款
           OR (/*TO_CHAR(A.DISTR_DT,'YYYYMMDD')  > '20190930' AND*/ D.FARM_FLG ='1' ) -- 是农户的
           OR (/*TO_CHAR(A.DISTR_DT,'YYYYMMDD') > '20190930'  -- 放款日期大于2019年9月30日
                AND*/ TTA.TAR_VALUE_CODE LIKE '0102%'
               AND (SUBSTR(B.DIR_INDUS_CD, 1, 4) IN ('C201','C204','C262','C263','C357','F511','G595')
                     OR SUBSTR(B.DIR_INDUS_CD, 1, 5) IN ('C1711','C1712','C1713','C1731','C1732','C1741',
                                                         'C1742','C2730','C2740','C2921','C3323','C4024',
                                                         'F5121','F5123','F5124','F5152','F5166','F5167',
                                                         'F5168','F5171','F5221','F5223','F5224','F5252',
                                                         'M7330','M7511','M7530'))
                                                         ));

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');


     V_STEP := 3; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入涉农贷款子表-联合网贷';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_AGR_REL_SUB
  (
      DATA_DT  --数据日期
      ,LGL_REP_ID  --法人编号
      ,ORG_ID  --机构编号
      ,RCPT_ID  --借据编号
      ,AGR_REL_LOAN_BIZ_TYP  --涉农贷款业务类型
      ,AGR_CPRSV_DVLP_LOAN_FLG  --农业综合开发贷款标志
      ,LOAN_CHAR  --贷款性质
      ,FARMER_COOP_LOAN_FLG  --农民合作社贷款标志
      ,VIL_THREE_RT_MTG_LOAN_CL  --农村三权抵押贷款分类
      ,VIL_COLLTV_ECON_ORG_LOAN_FLG  --农村集体经济组织贷款标志
      ,FARM_LOAN_FLG  --农户贷款标志
      ,TWO_RT_LOAN_GUA_MODE  --两权贷款担保方式
      ,FAMILY_FARM_LOAN_FLG  --家庭农场贷款标识
      ,DEPT_LINE  --部门条线
      ,DATA_SRC  --数据来源
      ,AGCLT_LOAN_MAIN_TYPE_CD   --涉农贷款主体类型代码  A1333使用     modify by 于敬艺 in20221111
  )
  SELECT
      V_P_DATE               DATA_DT  --数据日期
      ,T1.LP_ID               LGL_REP_ID  --法人编号
      ,T1.ACCT_INSTIT_ID        ORG_ID  --机构编号
      ,T1.DUBIL_ID            RCPT_ID  --借据编号
      ,CASE WHEN T1.DIR_INDUS_CD LIKE 'A%'  THEN 'A'
            ELSE 'Z'
       END                       AGR_REL_LOAN_BIZ_TYP  --涉农贷款业务类型
      ,'N'                       AGR_CPRSV_DVLP_LOAN_FLG  --农业综合开发贷款标志
      ,'1'                      LOAN_CHAR  --贷款性质
      ,'N' FARMER_COOP_LOAN_FLG  --农民合作社贷款标志
      ,NULL                  VIL_THREE_RT_MTG_LOAN_CL  --农村三权抵押贷款分类
      ,'N' VIL_COLLTV_ECON_ORG_LOAN_FLG  --农村集体经济组织贷款标志
      ,CASE WHEN T2.FARM_FLG = '1'THEN 'Y'
            ELSE'N'
            END  FARM_LOAN_FLG  --农户贷款标志
      ,'C'   TWO_RT_LOAN_GUA_MODE  --两权贷款担保方式
      ,'N'   FAMILY_FARM_LOAN_FLG  --家庭农场贷款标识        ----上游暂无标识
      ,NULL   DEPT_LINE  --部门条线
      ,'涉农-联合网贷' DATA_SRC  --数据来源
      ,NULL   --涉农贷款主体类型代码  A1333使用     modify by 于敬艺 in20221111
   FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO T1  --联合网贷借据信息
   LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO T2 --个人客户基本信息
        ON T1.CUST_ID = T2.CUST_ID
        AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   AND  (( T1.DIR_INDUS_CD LIKE 'A%' AND T1.STD_PROD_ID LIKE '20102%' )  --是农林牧渔业的  20102% --个人经营性贷款
           OR (T1.DIR_INDUS_CD LIKE 'C13%' AND T1.STD_PROD_ID LIKE '20102%') --是农副食品加工业的  20102% --个人经营性贷款
           OR (/*TO_CHAR(A.DISTR_DT,'YYYYMMDD')  > '20190930' AND*/ T2.FARM_FLG ='1' ) -- 是农户的
           OR (/*TO_CHAR(A.DISTR_DT,'YYYYMMDD') > '20190930'  -- 放款日期大于2019年9月30日
                AND*/ T1.STD_PROD_ID LIKE '20102%'
               AND (SUBSTR(T1.DIR_INDUS_CD, 1, 4) IN ('C201','C204','C262','C263','C357','F511','G595')
                     OR SUBSTR(T1.DIR_INDUS_CD, 1, 5) IN ('C1711','C1712','C1713','C1731','C1732','C1741',
                                                         'C1742','C2730','C2740','C2921','C3323','C4024',
                                                         'F5121','F5123','F5124','F5152','F5166','F5167',
                                                         'F5168','F5171','F5221','F5223','F5224','F5252',
                                                         'M7330','M7511','M7530'))
                                                         ));

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, RCPT_ID,COUNT(1)
      FROM M_LOAN_AGR_REL_SUB T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, RCPT_ID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

 -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序跑批结束记录 --
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_INIT_M_LOAN_AGR_REL_SUB;
/

