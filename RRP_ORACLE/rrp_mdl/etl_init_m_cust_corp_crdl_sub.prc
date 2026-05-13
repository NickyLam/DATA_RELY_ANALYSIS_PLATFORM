CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_CUST_CORP_CRDL_SUB(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_CUST_CORP_CRDL_SUB
  *  功能描述：监管集市对公客户的证件子表
  *  创建日期：20220608
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_CORP_CUST_BASIC_INFO   --对公客户基本信息
  *            IML.PTY_PARTY_CERT_INFO_H      --当事人证件信息历史
  *
  *  目标表：  M_CUST_CORP_CRDL_SUB --对公客户证件子表
  *
  *  配置表：  CODE_MAP --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220507  程序员   首次创建
  *             2    20220901  mw     增加码值表模块判定
  *             3    20221020  hulj   增加证件号过滤条件
  *             4    20221107  hulj   增加数据重复校验
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_CUST_CORP_CRDL_SUB'; -- 程序名称
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
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
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_CUST_CORP_CRDL_SUB'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  --V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;
  ----将参数转化为日期格式，判读输入参数是否符合日期要求



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
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入对公客户证件子表';

  INSERT  INTO M_CUST_CORP_CRDL_SUB
  (
  DATA_DT,        --数据日期
  LGL_REP_ID,     --法人编号
  CUST_ID,        --客户编号
  CRDL_TYP,       --证件类型
  CRDL_NO,        --证件号码
  CRDL_EFF_DT,    --证件生效日期
  CRDL_EXP_DT,    --证件失效日期
  CRDL_UPD_DT,    --证件更新日期
  DEPT_LINE,      --部门条线
  DATA_SRC,       --数据来源
  CRDL_TYP_ORIG   --原始证件类型
    )
  SELECT DISTINCT DATA_DT,
          LGL_REP_ID,
          CUST_ID,
          CRDL_TYP,
          CRDL_NO,
          CRDL_EFF_DT,
          CRDL_EXP_DT,
          CRDL_UPD_DT,
          DEPT_LINE,
          DATA_SRC,
          CRDL_TYP_ORIG
  FROM
  (SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')                 AS  DATA_DT  --数据日期
       ,A.LP_ID AS LGL_REP_ID  --法人编号
       ,A.CUST_ID AS CUST_ID  --客户编号
       ,/*NVL(C.TAR_VALUE_CODE,'0000')  */
        B.CERT_TYPE_CD                                  AS  CRDL_TYP  --证件类型
       ,B.CERT_NUM  AS CRDL_NO  --证件号码
     ,ROW_NUMBER() OVER(PARTITION BY A.ETL_DT
                    ,A.CUST_ID
                    ,C.TAR_VALUE_CODE
                    ,B.CERT_NUM
              ORDER BY B.CERT_EFFECT_DT DESC ) AS ROWNUMBER
       ,TO_CHAR(B.CERT_EFFECT_DT,'YYYYMMDD')           AS CRDL_EFF_DT  --证件生效日期
       ,TO_CHAR(B.CERT_INVALID_DT,'YYYYMMDD')          AS CRDL_EXP_DT  --证件失效日期
       ,NULL                                           AS CRDL_UPD_DT  --证件更新日期
       ,'04'                                           AS DEPT_LINE    --部门条线
       ,SUBSTR(A.JOB_CD,0,4)                           AS DATA_SRC    --数据来源
       ,B.CERT_TYPE_CD                                 AS CRDL_TYP_ORIG    --原始证件类型
  FROM O_ICL_CMM_CORP_CUST_BASIC_INFO A  --对公客户基本信息
  LEFT JOIN O_IML_PTY_PARTY_CERT_INFO_H B  --当事人证件信息历史
    ON A.CUST_ID = B.PARTY_ID
    AND B.START_DT <= A.ETL_DT
    AND B.END_DT > A.ETL_DT
  LEFT JOIN  CODE_MAP C
    ON B.CERT_TYPE_CD = C.SRC_VALUE_CODE
    AND C.SRC_CLASS_CODE = 'CD1014'
    AND C.MOD_FLG = 'MDM'
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   AND A.CUST_ID IS NOT NULL
   AND TRIM(B.CERT_NUM) IS NOT NULL
   AND B.CERT_TYPE_CD IS NOT NULL
   --AND B.CERT_EFFECT_DT <> TO_DATE('00010101','YYYYMMDD')
   AND REPLACE(B.CERT_NUM,'*','') IS NOT NULL
   AND REPLACE(B.CERT_NUM,'0','') IS NOT NULL --modify by hlj 20221020
   )
  WHERE /*CRDL_TYP IS NOT NULL
   AND */ROWNUMBER = 1
   ;
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
      FROM M_CUST_CORP_CRDL_SUB T
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

  END ETL_INIT_M_CUST_CORP_CRDL_SUB;
/

