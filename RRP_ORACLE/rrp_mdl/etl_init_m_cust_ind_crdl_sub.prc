CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_CUST_IND_CRDL_SUB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_CUST_IND_CRDL_SUB
  *  功能描述：监管集市自然人客户的证件信息，该表记录了当事人的居民身份证、军人身份证等证件信息历史
  *  创建日期：20220607
  *  开发人员：hulijuan
  *  来源表：  IML.PTY_PARTY_CERT_INFO_H --当事人证件信息历史
  *
  *  目标表：  M_CUST_IND_CRDL_SUB  --个人客户证件子表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220507  程序员   EAST5校验规则调整，同步进行程序修改。
  *             2    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             3    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             4    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             5    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_CUST_IND_CRDL_SUB'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_CUST_IND_CRDL_SUB'; --表名
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
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '自然人客户的证件信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_CUST_IND_CRDL_SUB
  (
   DATA_DT                --数据日期
  ,LGL_REP_ID             --法人编号
  ,CUST_ID                --客户编号
  ,CRDL_TYP               --证件类型
  ,CRDL_NO                --证件号码
  ,ISU_CERT_OFF_AREA_CD   --发证机关行政区划代码
  ,CRDL_EFF_DT            --证件生效日期
  ,CRDL_EXP_DT            --证件失效日期
  ,CRDL_ADDR              --证件地址
  ,DEPT_LINE              --部门条线
  ,DATA_SRC               --数据来源
  )
  SELECT
     V_P_DATE                        AS DATA_DT                       --数据日期
    ,A.LP_ID                                              AS LGL_REP_ID                    --法人编号
    ,A.PARTY_ID                                           AS CUST_ID                       --客户编号
    ,A.CERT_TYPE_CD                                       AS CRDL_TYP                      --证件类型
    ,A.CERT_NUM
    ,C.LICEN_ISSUE_AUTHO_DIST_CD                          AS ISU_CERT_OFF_AREA_CD          --发证机关行政区划代码
    ,C.CRDL_EFF_DT                                        AS CRDL_EFF_DT                   --证件生效日期
    ,C.CRDL_EXP_DT                                        AS CRDL_EXP_DT                   --证件失效日期
    ,C.CRDL_ADDR                                          AS CRDL_ADDR                     --证件地址
    ,'800924' /*零售信贷部(普惠金融部)*/                  AS DEPT_LINE                     --部门条线
    ,null/*SUBSTR(A.JOB_CD, 0, 4)    */                           AS DATA_SRC                      --数据来源
   FROM RRP_MDL.O_IML_PTY_PARTY_CERT_INFO_H  A --当事人证件信息历史
   INNER JOIN O_ICL_CMM_INDV_CUST_BASIC_INFO B
         ON A.PARTY_ID =B.CUST_ID
         AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')   --关联个人表剔除对公客户
   LEFT JOIN (
    SELECT CC.PARTY_ID,CC.LICEN_ISSUE_AUTHO_DIST_CD,CC.CRDL_EFF_DT,CC.CRDL_EXP_DT,CC.CRDL_ADDR
    FROM (
      SELECT
         PARTY_ID
        ,LICEN_ISSUE_AUTHO_DIST_CD
        ,TO_CHAR(CERT_EFFECT_DT,'YYYYMMDD')  AS CRDL_EFF_DT    --证件生效日期
        ,TO_CHAR(CERT_INVALID_DT,'YYYYMMDD') AS CRDL_EXP_DT    --证件失效日期
        ,CERT_ADDR                           AS CRDL_ADDR      --证件地址
        ,ROW_NUMBER() OVER(PARTITION BY PARTY_ID ORDER BY START_DT,SORC_SYS_CD DESC) AS RN
      FROM RRP_MDL.O_IML_PTY_PARTY_CERT_INFO_H  --当事人证件信息历史
      WHERE TO_DATE(V_P_DATE,'YYYYMMDD') BETWEEN TO_DATE(TO_CHAR(START_DT,'YYYYMMDD'),'YYYYMMDD') AND TO_DATE(TO_CHAR(END_DT,'YYYYMMDD'),'YYYYMMDD')
      AND TRIM(LICEN_ISSUE_AUTHO_DIST_CD) IS NOT NULL -- 发证机关代码不为空
      ) CC
    WHERE CC.RN = 1
   ) C
   ON A.PARTY_ID = C.PARTY_ID
   WHERE SUBSTR(A.SORC_SYS_CD,0,4) = 'icms';

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, CUST_ID,CRDL_NO,CRDL_TYP,COUNT(1)
      FROM M_CUST_IND_CRDL_SUB T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, CUST_ID,CRDL_NO,CRDL_TYP
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

  END ETL_INIT_M_CUST_IND_CRDL_SUB;
/

