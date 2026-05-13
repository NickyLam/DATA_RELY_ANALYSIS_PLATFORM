CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_CPTL_PEERS(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_CPTL_PEERS
  *  功能描述：同业业务整合表
  *  创建日期：20220507
  *  开发人员：蔡正伟
  *  来源表：  M_CPTL_AST_INFO
  *            M_CPTL_LBY_INFO
  *            M_CUST_CORP_INFO
  *
  *
  *
  *
  *  目标表：  S_CPTL_PEERS
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *           1     20230113  HYF     修改账户类型，由定活标志判断活期与定期
  *           2     20230817  HYF     新增转贷款标志
  *           3     20240109  HYF     剔除余额大于0过滤，否则利息不准
  *           4     20240110  HYF     外汇同业拆借已到期的明细其利息置调整为0，同业系统没有送核算中台记账
  *           5     20240621  HYF     修改同业代付部分金融机构类型和境内外标志及由于国结系统送过来的客户号
                                      存的是客户分类，调整为取代付行名称方便G27报表统计户数
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_CPTL_PEERS'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_CPTL_PEERS'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_CPTL_PEERS T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_CPTL_PEERS'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


 -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '同业业务整合表--资产业务';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_CPTL_PEERS
      ( DATA_DT                         --数据日期
       ,LGL_REP_ID                      --法人编号
       ,ACC_ID                          --账户编号
       ,CUST_ID                         --客户编号
       ,CUR                             --币种
       ,BAL                             --余额
       ,INT                             --利息
       ,ORG_NO                          --机构编号
       ,FIN_ORG_TYP                     --金融机构类型
       ,FIN_ORG_ID                      --金融机构编号
       ,FIN_ORG_NM                      --客户名称
       ,BIZ_TYP                         --业务类型
       ,ACC_TYP                         --账户类型
       ,TERM_TYP                        --期限类型
       ,EXP_DT                          --到期日期
       ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG   --外汇储备委托贷款资金标志
       ,BIO_FLG                         --境内外标志
       ,PEERS_PAY_FLG                   --同业代付标志
       ,SETL_PEERS_DEP_FLG              --结算性同业存款标志
       ,DEPT_LINE                       --部门条线
       ,DATA_SRC                        --数据来源
       ,MIC_COP_FLG                     --小额贷款公司标志
       ,TIME_DWD_FLG                    --定活标志
       ,SUBJ_ID                         --科目号
       ,TRANS_LOAN_FLG                  --转贷款标志
       )
      SELECT  A.DATA_DT                     AS DATA_DT                    --数据日期
             ,A.LGL_REP_ID                  AS LGL_REP_ID                 --法人编号
             ,A.ACC_ID                      AS ACC_ID                     --账户编号
             ,CASE WHEN A.BIZ_TYP = '10203' 
                   THEN A.ERA_PAY_BANK_CUST_NAME
                   ELSE A.CUST_ID 
               END                          AS CUST_ID                    --客户编号
             ,A.CUR                         AS CUR                        --币种
             ,A.BAL                         AS BAL                        --余额
             ,CASE WHEN A.BIZ_TYP = '10203' AND A.BUS_ID = 'TR8072300001' THEN 1232.32
                   WHEN A.BIZ_TYP = '10203' AND A.BUS_ID = 'TR8072300002' THEN 1889.39
                   WHEN A.BIZ_TYP = '10203' AND A.BUS_ID = 'TR8072300003' THEN 1380.65
                   WHEN A.BIZ_TYP = '10203' AND A.BUS_ID = 'TR8072300004' THEN 920.76
                   WHEN A.BIZ_TYP = '10203' AND A.BUS_ID = 'TR8072300005' THEN 801.05
                   WHEN A.BIZ_TYP = '10203' AND A.BUS_ID = 'TR8072300006' THEN 1184.68
                   WHEN A.BIZ_TYP = '10203' AND A.BUS_ID = 'TR8072300007' THEN 1985.94
                   WHEN A.BIZ_TYP = '10203' AND A.BUS_ID = 'TR8072300008' THEN 1392.96
                   ELSE A.INT 
               END                          AS INT                        -- 利息
             ,A.ORG_ID                      AS ORG_NO                     --机构编号
             ,CASE WHEN A.BIZ_TYP = '10203' AND A.CUST_ID = '101' THEN 'C12000' --101 境内商业银行
                   WHEN A.BIZ_TYP = '10203' AND A.CUST_ID = '102' THEN 'D20000' --102 境内其他银行业金融机构
                   WHEN A.BIZ_TYP = '10203' AND A.CUST_ID = '103' THEN 'E10000' --103 境内证券业金融机构
                   WHEN A.BIZ_TYP = '10203' AND A.CUST_ID = '104' THEN 'F10000' --104 境内保险业金融机构
                   WHEN A.BIZ_TYP = '10203' AND A.CUST_ID = '105' THEN 'Z90000' --105 境内保险业金融机构
                   WHEN A.BIZ_TYP = '10203' AND A.CUST_ID = '201' THEN 'Z91000' --201 境外金融机构
                   ELSE B.FIN_ORG_TYP 
               END                          AS FIN_ORG_TYP                --金融机构类型
             ,B.FIN_ORG_ID                  AS FIN_ORG_ID                 --金融机构编号
             ,CASE WHEN A.BIZ_TYP = '10203' THEN A.ERA_PAY_BANK_CUST_NAME
                   ELSE B.CUST_NM 
               END                          AS FIN_ORG_NM                 --客户名称
             ,A.BIZ_TYP                     AS BIZ_TYP                    --业务类型
             ,CASE WHEN TRIM(A.TIME_DWD_FLG) = '0' THEN 'A'
                   ELSE 'B'
               END                          AS ACC_TYP                    --账户类型
             ,CASE WHEN /*A.BIZ_TYP = '102' AND*/
                        MONTHS_BETWEEN(TO_DATE(A.EXP_DT, 'YYYY-MM-DD'),TO_DATE(A.START_DT, 'YYYY-MM-DD')) <= 12 
                   THEN 'S' ---短期
                   WHEN /*A.BIZ_TYP = '102' AND*/
                        MONTHS_BETWEEN(TO_DATE(A.EXP_DT, 'YYYY-MM-DD'),TO_DATE(A.START_DT, 'YYYY-MM-DD')) > 12 
                    AND MONTHS_BETWEEN(TO_DATE(A.EXP_DT, 'YYYY-MM-DD'),TO_DATE(A.START_DT, 'YYYY-MM-DD')) <= 60 
                   THEN 'M' --中期
                   WHEN /*A.BIZ_TYP = '102' AND*/
                        MONTHS_BETWEEN(TO_DATE(A.EXP_DT, 'YYYY-MM-DD'),TO_DATE(A.START_DT, 'YYYY-MM-DD')) > 60 
                   THEN 'L' --长期
                END                          AS TERM_TYP                   --期限类型
             ,A.EXP_DT                       AS EXP_DT                     --到期日期
             ,A.FOREX_RSV_ENTRS_LOAN_CPTL_FLG AS FOREX_RSV_ENTRS_LOAN_CPTL_FLG --外汇储备委托贷款资金标志
             ,CASE WHEN A.BIZ_TYP = '10203' AND A.CUST_ID IN ('101','102','103','104','105') THEN 'Y'
                   WHEN A.BIZ_TYP = '10203' AND A.CUST_ID = '201' THEN 'N'
                   ELSE B.BIO_FLG 
                END                          AS BIO_FLG           --境内外标志
             ,A.PEERS_PAY_FLG                AS PEERS_PAY_FLG              -- 同业代付标志
             ,A.SETL_PEERS_DEP_FLG           AS SETL_PEERS_DEP_FLG         -- 结算性同业存款标志
             ,A.DEPT_LINE                    AS DEPT_LINE                  --部门条线
             ,A.DATA_SRC                     AS DATA_SRC                   --数据来源
             ,CASE WHEN B.CUST_NM LIKE '%小额贷款%' OR B.CUST_NM LIKE '%小额再贷款%'
                   THEN 'Y'
                   ELSE 'N'
               END                           AS MIC_COP_FLG                --小额贷款公司标志
             ,A.TIME_DWD_FLG                 AS TIME_DWD_FLG               --定活标志
             ,A.SUBJ_ID                      AS SUBJ_ID                    --科目号
             ,'0'                            AS TRANS_LOAN_FLG              --转贷款标志
        FROM M_CPTL_AST_INFO A --资金业务（资产方）信息
        LEFT JOIN M_CUST_CORP_INFO B --对公客户信息表
          ON A.CUST_ID = B.CUST_ID
         AND B.DATA_DT = V_P_DATE
       WHERE A.DATA_DT = V_P_DATE
         ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_CPTL_PEERS字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 4;
  V_STEP_DESC := '同业业务整合表--负债业务';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_CPTL_PEERS
      ( DATA_DT                       --数据日期
       ,LGL_REP_ID                    --法人编号
       ,ACC_ID                        --账户编号
       ,CUST_ID                       --客户编号
       ,CUR                           --币种
       ,BAL                           --余额
       ,INT                           --利息
       ,ORG_NO
       ,FIN_ORG_TYP                   --金融机构类型
       ,FIN_ORG_ID                    --金融机构编号
       ,FIN_ORG_NM                    --金融机构名称
       ,BIZ_TYP                       --业务类型
       ,ACC_TYP                       --账户类型
       ,TERM_TYP                      --期限类型
       ,EXP_DT                        --到期日期
       ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG --外汇储备委托贷款资金标志
       ,BIO_FLG                       --境内外标志
       ,PEERS_PAY_FLG                 --同业代付标志
       ,SETL_PEERS_DEP_FLG            --结算性同业存款标志
       ,DEPT_LINE                     --部门条线
       ,DATA_SRC                      --数据来源
       ,MIC_COP_FLG                   --小额贷款公司标志
       ,TIME_DWD_FLG                  --定活标志
       ,SUBJ_ID                       --科目编号
       ,TRANS_LOAN_FLG                --转贷款标志
       )
      SELECT  A.DATA_DT                      AS DATA_DT            --数据日期
             ,A.LGL_REP_ID                   AS LGL_REP_ID         --法人编号
             ,A.ACC_ID                       AS ACC_ID             --账户编号
             ,A.CUST_ID                      AS CUST_ID            --客户编号
             ,A.CUR                          AS CUR                --币种
             ,A.BAL                          AS BAL                --余额
             ,CASE WHEN A.DATA_SRC = '外汇同业拆借'
                    AND TO_DATE(A.EXP_DT, 'YYYY-MM-DD') <= TO_DATE(V_P_DATE, 'YYYY-MM-DD')
                   THEN 0
                   ELSE A.INT 
               END                           AS INT                --利息
             ,A.ORG_ID
             ,B.FIN_ORG_TYP                  AS FIN_ORG_TYP        --金融机构类型
             ,B.FIN_ORG_ID                   AS FIN_ORG_ID         --金融机构编号
             ,B.CUST_NM                      AS FIN_ORG_NM         --金融机构名称
             ,A.BIZ_TYP                      AS BIZ_TYP            --业务类型
             ,CASE WHEN TRIM(A.TIME_DWD_FLG) = '0'
                   THEN 'A'
                   ELSE 'B'
               END                           AS ACC_TYP            --账户类型
             ,CASE WHEN /*A.BIZ_TYP = '202' AND*/
                        MONTHS_BETWEEN(TO_DATE(A.EXP_DT, 'YYYY-MM-DD'),TO_DATE(A.START_DT, 'YYYY-MM-DD')) <= 12 
                   THEN 'S' ---短期
                   WHEN /*A.BIZ_TYP = '202' AND*/
                        MONTHS_BETWEEN(TO_DATE(A.EXP_DT, 'YYYY-MM-DD'),TO_DATE(A.START_DT, 'YYYY-MM-DD')) > 12 
                    AND MONTHS_BETWEEN(TO_DATE(A.EXP_DT, 'YYYY-MM-DD'),TO_DATE(A.START_DT, 'YYYY-MM-DD')) <= 60 
                   THEN 'M' --中期
                   WHEN /*A.BIZ_TYP = '202' AND*/
                        MONTHS_BETWEEN(TO_DATE(A.EXP_DT, 'YYYY-MM-DD'),TO_DATE(A.START_DT, 'YYYY-MM-DD')) > 60 
                   THEN 'L' --长期
               END                           AS TERM_TYP            --期限类型
             ,A.EXP_DT                       AS EXP_DT              --到期日期
             ,A.FOREX_RSV_ENTRS_LOAN_CPTL_FLG AS FOREX_RSV_ENTRS_LOAN_CPTL_FLG --外汇储备委托贷款资金标志
             ,B.BIO_FLG                      AS BIO_FLG             --境内外标志
             ,A.PEERS_PAY_FLG                AS PEERS_PAY_FLG       --同业代付标志
             ,A.SETL_PEERS_DEP_FLG           AS SETL_PEERS_DEP_FLG  --结算性同业存款标志
             ,A.DEPT_LINE                    AS DEPT_LINE           --部门条线
             ,A.DATA_SRC                     AS DATA_SRC            --数据来源
             ,CASE WHEN B.CUST_NM LIKE '%小额贷款%' OR B.CUST_NM LIKE '%小额再贷款%'
                  THEN 'Y'
                  ELSE 'N'
              END                            AS MIC_COP_FLG         --小额贷款公司标志
             ,A.TIME_DWD_FLG                 AS TIME_DWD_FLG        --定活标志
             ,A.SUBJ_ID                                             --科目号
             ,DECODE(A.TRANS_LOAN_FLG,'1','1','0') AS TRANS_LOAN_FLG
        FROM RRP_MDL.M_CPTL_LBY_INFO A --资金业务（负债方）信息
        LEFT JOIN RRP_MDL.M_CUST_CORP_INFO B --对公客户信息表
          ON A.CUST_ID = B.CUST_ID
         AND B.DATA_DT = V_P_DATE
       WHERE A.BIZ_TYP <> '20203' --资产方已有该部分数据
         AND A.DATA_DT = V_P_DATE;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

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
     O_ERRCODE := '0';
     V_ENDTIME := SYSDATE;
   V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_S_CPTL_PEERS;
/

