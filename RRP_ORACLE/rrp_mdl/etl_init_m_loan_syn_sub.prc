CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_LOAN_SYN_SUB(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_LOAN_SYN_SUB
  *  功能描述：银团贷款子表
  *  创建日期：20220523
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_LOAN_SYN_SUB
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220523  梅炜      首次创建
                2    20221102  LHQ       改为新一代科目码值
                3    20221103  MW        根据上游口径更改与贷款申请信息的关联口径
                4    20221114  hulj      增加数据重复校验
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_LOAN_SYN_SUB'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_LOAN_SYN_SUB'; --表名
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
  V_STEP_DESC := '银团贷款子表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_SYN_SUB
  (
      DATA_DT  --数据日期
      ,LGL_REP_ID  --法人编号
      ,CONT_ID  --合同编号
      ,LEAD_BANK_PBC_NO  --牵头行行号
      ,ATND_BANK_PBC_NO  --参加行行号
      ,AGCY_BANK_PBC_NO  --代理行行号
      ,LEAD_BANK_NM  --牵头行名称
      ,ATND_BANK_NM  --参加行行名
      ,AGCY_BANK_NM  --代理行行名
      ,AGCY_PART_LOAN_FLG  --代理参贷标志
      ,CUR  --币种
      ,SYN_LOAN_TOT_AMT  --银团贷款总金额
      ,BEAR_LOAN_AMT  --承担贷款金额
      ,DSTR_SYN_LOAN_AMT  --已发放银团贷款金额
      ,DSTR_BEAR_LOAN_AMT  --已发放承担贷款金额
      ,DEPT_LINE  --部门条线
      ,DATA_SRC  --数据来源
      )
    SELECT
       TO_CHAR(B.ETL_DT,'YYYYMMDD')        DATA_DT        --数据日期
      ,B.LP_ID                              LGL_REP_ID    --法人编号
      ,B.CONT_ID                            CONT_ID        --合同编号
      ,T2.HOST_BANK_NO                    LEAD_BANK_PBC_NO  --牵头行行号
      ,T2.PATIP_LOAN_BANK_NO            ATND_BANK_PBC_NO  --参加行行号
      ,T2.AGENT_BANK_NO                AGCY_BANK_PBC_NO  --代理行行号
      ,T4.HOST_BANK_NAME                      LEAD_BANK_NM    --牵头行名称
      ,T4.PATIP_LOAN_BANK_NAME                ATND_BANK_NM    --参加行行名
      ,T4.AGENT_BANK_NAME                     AGCY_BANK_NM    --代理行行名
     /* ,CASE WHEN B.AGENT_PATIP_LOAN_FLG IN ('0','1','4') THEN '0' --牵头行
          WHEN B.AGENT_PATIP_LOAN_FLG IN ('2','5') THEN '2' --参贷行
          WHEN B.AGENT_PATIP_LOAN_FLG IN ('3') THEN '1' --代理行
          END                              AGCY_PART_LOAN_FLG      --代理参贷标志*/
      ,CASE WHEN B.STD_PROD_ID IN ('203010400001','602060100001')  THEN '0' --牵头行
            WHEN B.STD_PROD_ID IN ('203010400002')  THEN '2' --参贷行
            WHEN B.STD_PROD_ID IN ('602060100002')  THEN '1' --代理行
       END                                  AGCY_PART_LOAN_FLG      --代理参贷标志  ---modify by tangan at 20221121 代理参贷标志应通过标准产品进行映射
      ,B.CURR_CD                             CUR                    --币种
      ,T2.SYN_LOAN_TOT_AMT                   SYN_LOAN_TOT_AMT        --银团贷款总金额
      ,B.CONT_AMT                          BEAR_LOAN_AMT          --承担贷款金额
      ,B.SYN_LOAN_DISTR_AMT                 DSTR_SYN_LOAN_AMT      --已发放银团贷款金额
      ,B.ACM_DISTR_AMT                        DSTR_BEAR_LOAN_AMT    --已发放承担贷款金额
      ,'800919'   /*风险管理部'02'*/                                   DEPT_LINE            --部门条线
      ,SUBSTR(B.JOB_CD,1,4)                    DATA_SRC            --数据来源
      FROM O_ICL_CMM_CORP_LOAN_CONT_INFO B --对公贷款合同信息
      /*RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO A--对公贷款账户信息
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO B --对公贷款合同信息
        ON B.CONT_ID = A.CONT_ID
        and B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')*/
/*      LEFT JOIN ( SELECT  CONT_ID,
                SUBSTR(LISTAGG(HOST_BANK_NO,',') WITHIN GROUP (ORDER BY NULL),0,100) AS HOST_BANK_NO,
                SUBSTR(LISTAGG(PATIP_LOAN_BANK_NO,',') WITHIN GROUP (ORDER BY NULL),0,100) AS PATIP_LOAN_BANK_NO,
                SUBSTR(LISTAGG(AGENT_BANK_NO,',') WITHIN GROUP (ORDER BY NULL),0,100) AS AGENT_BANK_NO
            FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO --对公贷款合同信息
            WHERE ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD')
             GROUP BY CONT_ID) D---代理行、参加行、牵头行行号
        ON A.CONT_ID = D.CONT_ID */
/*     LEFT JOIN (SELECT CONT_ID,MAX(HOST_BANK_NO) HOST_BANK_NO,MAX(PATIP_LOAN_BANK_NO) PATIP_LOAN_BANK_NO,MAX(AGENT_BANK_NO) AGENT_BANK_NO
                FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO --对公贷款合同信息
                WHERE ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD')
                GROUP BY CONT_ID) D
         ON A.CONT_ID = D.CONT_ID*/
       LEFT JOIN O_ICL_CMM_CORP_LOAN_CONT_INFO T2
            ON B.LMT_CONT_ID = T2.CONT_ID
            AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       LEFT JOIN O_ICL_CMM_CORP_CRDT_LMT_APV_INFO T3
             ON T2.APV_FLOW_NUM = T3.CRDT_LMT_APV_FLOW_NUM
             AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       LEFT JOIN O_ICL_CMM_CORP_LOAN_APPL_INFO T4
             ON T3.RELA_CRDT_LMT_APV_FLOW_NUM = T4.LOAN_APPL_FLOW_NUM
             AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')            --MODIFY BY MW 20221103
      /* LEFT JOIN ( SELECT  RELA_APPL_FLOW_NUM,
                SUBSTR(LISTAGG(HOST_BANK_NAME,',') WITHIN GROUP (ORDER BY NULL),0,100) AS HOST_BANK_NAME,
                SUBSTR(LISTAGG(PATIP_LOAN_BANK_NAME,',') WITHIN GROUP (ORDER BY NULL),0,100) AS PATIP_LOAN_BANK_NAME,
                SUBSTR(LISTAGG(AGENT_BANK_NAME,',') WITHIN GROUP (ORDER BY NULL),0,100) AS AGENT_BANK_NAME
            FROM O_ICL_CMM_CORP_LOAN_APPL_INFO   --对公贷款申请信息
            WHERE ETL_DT  =  TO_DATE(V_P_DATE,'YYYYMMDD')
             GROUP BY RELA_APPL_FLOW_NUM) C---代理行、参加行、牵头行行名
        ON B.APV_FLOW_NUM = C.RELA_APPL_FLOW_NUM */
  /*     LEFT JOIN (SELECT RELA_APPL_FLOW_NUM,MAX(HOST_BANK_NAME) HOST_BANK_NAME,MAX(PATIP_LOAN_BANK_NAME) PATIP_LOAN_BANK_NAME,MAX(AGENT_BANK_NAME) AGENT_BANK_NAME
                FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_APPL_INFO   --对公贷款申请信息
                WHERE ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD')
                GROUP BY RELA_APPL_FLOW_NUM) C
         ON B.APV_FLOW_NUM = C.RELA_APPL_FLOW_NUM*/
       WHERE/* B.SUBJ_ID IN ('13030104','13030104')   --modify LHQ 20221102 改为新一代科目*/
       B.STD_PROD_ID IN ('203010400001','203010400002','602060100001','602060100002') --modify mw 20221102   '203010400001','203010400002' 银团贷款  '602060100001'，'602060100002 表外银团贷款
       AND  B.CONT_ID IS NOT NULL
       AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       AND B.SYN_LOAN_TOT_AMT IS NOT NULL
       AND B.CONT_AMT IS NOT NULL
       AND B.SYN_LOAN_DISTR_AMT IS NOT NULL
       AND B.ACM_DISTR_AMT IS NOT NULL;


   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, CONT_ID,COUNT(1)
      FROM M_LOAN_SYN_SUB T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, CONT_ID
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

  END ETL_INIT_M_LOAN_SYN_SUB;
/

