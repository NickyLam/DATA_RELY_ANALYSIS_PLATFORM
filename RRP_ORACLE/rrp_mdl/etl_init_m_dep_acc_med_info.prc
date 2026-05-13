CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_DEP_ACC_MED_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_DEP_ACC_MED_INFO
  *  功能描述：监管集市银行普通存折，存单，一本通，大额定期存单，其他。
  *  创建日期：20220525
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_DEP_CUST_ACCT_INFO    --存款主账户信息
  *            IML.AGT_VOUCH_ACCT_RELA_H     --凭证账户关系历史
  *            ICL.CMM_DEP_ACCT_INFO         --存款分户信息
  *            ICL.CMM_INDV_CUST_BASIC_INFO  --个人客户基本信息
  *            IML.REF_PUB_CD                --公共码值表
  *  目标表：  M_DEP_ACC_MED_INFO  --存款介质信息表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221114  hulj     增加数据重复校验。
  *             2    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             3    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             4    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             5    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_DEP_ACC_MED_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  --V_START_DT   VARCHAR2(8);  --月初
  V_DATE       DATE; --数据日期(判断输入参数日期格式是否准确)
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
 V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_DATE := TO_DATE(V_P_DATE,'YYYYMMDD');
  --V_START_DT := TO_CHAR(TRUNC(V_DATE, 'MM'), 'YYYYMMDD');
  V_TAB_NAME := 'M_DEP_ACC_MED_INFO'; --表名
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
  V_STEP_DESC := '存款介质信息表';
  V_STARTTIME := SYSDATE;

 /***普通存折存单***/
  INSERT INTO M_DEP_ACC_MED_INFO
    (
     DATA_DT        --数据日期
    ,LGL_REP_ID     --法人编号
    ,ORG_ID         --机构编号
    ,MED_ID         --介质编号
    ,CUST_ID        --客户编号
    ,ACC_MED        --账户介质
    ,MED_STAT       --介质状态
    ,ENABLE_DT      --启用日期
    ,ENABLE_TLR_NO  --启用柜员号
    ,DEPT_LINE      --部门条线
    ,DATA_SRC       --数据来源
     )
  SELECT
    TO_CHAR(A.ETL_DT, 'YYYYMMDD'),                                              --数据日期
    A.LP_ID,                                                                    --法人编号
    NVL(A.ACCT_BELONG_ORG_ID, B.ORG_ID),                                                                  --机构编号
    NVL(C.AGT_ID, A.CUST_ACCT_ID),                                              --介质编号
    --A.CUST_ACCT_ID,
    A.CUST_ID,                                                                  --客户编号
    CASE WHEN A.VOUCH_KIND_CD IN ('737','771') THEN  '02'       --存单
     WHEN A.VOUCH_KIND_CD = '735'  THEN '03'                    --一本通
     WHEN A.VOUCH_KIND_CD = '731'  THEN '01'                    --存折
     WHEN A.VOUCH_KIND_CD = '772' THEN '99' END,               --其他           --账户介质
    /*CASE WHEN F.CD_DESCB = '正常' THEN '02'
     WHEN F.CD_DESCB = '关闭' THEN '04'
     WHEN F.CD_DESCB = '睡眠' THEN '07'
     WHEN F.CD_DESCB = '未激活' THEN '01'
     WHEN F.CD_DESCB LIKE '%冻结%' THEN '06'
   WHEN F.CD_ID = '05' THEN '9901' --不进不出-未使用
   WHEN F.CD_ID = '06' THEN '9902' --结清
   WHEN F.CD_ID = '07' THEN '9903' --预开户
     ELSE '99' END*/
  /*MODIFY BY cxl 20220520 更改账户状态为取主账户状态*/
 /* CASE WHEN A.ACCT_STATUS_CD = '0' THEN '04' --销户
       WHEN A.ACCT_STATUS_CD = '1' THEN '02' --正常
       WHEN A.ACCT_STATUS_CD = '2' THEN '06' --冻结
  ELSE '99' END,*/
  NVL(TA.TAR_VALUE_CODE ,'00') ,                                                --介质状态
    TO_CHAR(A.OPEN_ACCT_DT, 'YYYYMMDD'),                                        --启用日期
    A.OPEN_ACCT_TELLER_ID,                                                      --启用柜员号
    '800001',  /*营运管理部*/                                                   --部门条线
    SUBSTR(A.JOB_CD, 0 ,4)                                                      --数据来源
  FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO A --存款主账户信息
  LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B   --内部机构信息
    ON A.ACCT_BELONG_ORG_ID = B.ORG_ID
    AND B.ETL_DT = to_date(V_P_DATE,'yyyymmdd')
  LEFT JOIN (
    SELECT T.AGT_ID, T.CUST_ACCT_NUM
      FROM
        (SELECT AGT_ID, CUST_ACCT_NUM, ROW_NUMBER() OVER(PARTITION BY CUST_ACCT_NUM ORDER BY SUB_ACCT_NUM, VOUCH_STATUS_CD DESC) AS ARANK
        FROM RRP_MDL.O_IML_AGT_VOUCH_ACCT_RELA_H--凭证账户关系历史

        WHERE START_DT <= to_date(V_P_DATE,'yyyymmdd') AND END_DT > to_date(V_P_DATE,'yyyymmdd')) T
      WHERE T.ARANK = 1 --账号凭证对照(按照ACCTNO分组，子户号和状态（倒序）排序，取第一条)
  ) C --凭证号临时表
    ON C.CUST_ACCT_NUM = A.CUST_ACCT_ID
  LEFT JOIN (
    SELECT T.ACCT_ID, T.CUST_ACCT_ID, T.DEP_ACCT_STATUS_CD
       FROM (SELECT ACCT_ID,
                 CUST_ACCT_ID,
                 DEP_ACCT_STATUS_CD,
                 ROW_NUMBER() OVER(PARTITION BY CUST_ACCT_ID ORDER BY ACCT_ID, OPEN_ACCT_TM) AS ARANK
            FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO
            WHERE ETL_DT = to_date(V_P_DATE,'yyyymmdd')) T
       WHERE T.ARANK = 1
  ) D --存款分户账临时表
    ON D.CUST_ACCT_ID= A.CUST_ACCT_ID
  LEFT JOIN CHG_ACCT_TMP CAT --换卡临时表 沿用存款账户介质关系信息表(ETL_B_DEP_ACC_MED_REL_INFO)中加工好的临时表
    ON D.ACCT_ID = CAT.ACCT_ID
    AND A.CUST_ACCT_ID = CAT.CUST_ACCT_ID /*过滤掉换卡的账户*/
  LEFT JOIN TMP_CBS_DECD_TEMP E --大额存单临时表 沿用存款账户介质关系信息表(ETL_B_DEP_ACC_MED_REL_INFO)中加工好的临时表
    ON A.CUST_ACCT_ID = E.MED_ID
  LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD F --账户状态
    ON F.CD_VAL = A.ACCT_STATUS_CD --更改账户状态
  /*NVL(D.DEP_ACCT_STATUS_CD, CAT.DEP_ACCT_STATUS_CD)*/
    AND F.CD_ID ='CD1253'
  LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD G
    ON G.CD_VAL = A.VOUCH_KIND_CD --凭证种类
    AND F.CD_ID = 'CD1315'
  LEFT JOIN RRP_MDL.CODE_MAP  TA
  ON TA.SRC_VALUE_CODE = A.ACCT_STATUS_CD
  AND TA.SRC_CLASS_CODE = 'CD2544'
  AND TA.TAR_CLASS_CODE = 'D0042'   --介质
  AND TA.MOD_FLG = 'MDM'            --监管集市明细层
  WHERE A.VOUCH_KIND_CD IN ('731','737','735','771', '772')
    AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND UPPER(A.JOB_CD) <> 'IFCSF1' --去除微众数据
    AND (CASE WHEN TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD') IN ('00010101','20991231')
               THEN '20991231'
               ELSE TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD') END) >= V_START_DT--过滤掉销户
    AND E.MED_ID IS NULL --筛选掉大额存单部分
    AND NVL(D.ACCT_ID, CAT.ACCT_ID) IS NOT NULL
 ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  COMMIT;

  ---记录正常日志
ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入存款介质信息-大额存单数据信息';
  V_STARTTIME := SYSDATE;
  /*** 大额存单 ***/

  INSERT INTO M_DEP_ACC_MED_INFO
    (
    DATA_DT                --数据日期
    ,LGL_REP_ID             --法人编号
    ,ORG_ID                 --机构编号
    ,MED_ID                 --介质编号
    ,CUST_ID                --客户编号
    ,ACC_MED                --账户介质
    ,MED_STAT               --介质状态
    ,ENABLE_DT              --启用日期
    ,ENABLE_TLR_NO          --启用柜员号
    ,DEPT_LINE              --部门条线
    ,DATA_SRC               --数据来源
     )
  SELECT
    I_P_DATE,                                                                 --数据日期
    '9999',                                                                     --法人编号
    NVL(A.BELONG_ORG_ID, B.ORG_ID),                                             --机构编号
    A.CUST_ACCT_ID,                                                             --介质编号
    A.CUST_ID,                                                                  --客户编号
    '04',                                                                        --账户介质
    --A.DEP_ACCT_STATUS_CD,
 /* CASE WHEN C.ACCT_STATUS_CD = '0' THEN '04' --销户
       WHEN C.ACCT_STATUS_CD = '1' THEN '02' --正常
       WHEN C.ACCT_STATUS_CD = '2' THEN '06' --冻结
  ELSE '99' END,/*modify by cxl*/
      NVL(TA.TAR_VALUE_CODE ,'00') ,                                              --介质状态
    TO_CHAR(A.OPEN_ACCT_DT, 'YYYYMMDD'),                                        --启用日期
    A.OPEN_ACCT_TELLER_ID,                                                      --启用柜员号
    '800001', /*营运管理部*/                                                    --部门条线
    SUBSTR(A.JOB_CD, 0 ,4)                                                      --数据来源
  FROM (
        SELECT T.*
        FROM
        (SELECT A.CUST_ACCT_ID, A.ACCT_ID, A.BELONG_ORG_ID, A.CUST_ID,
               A.OPEN_ACCT_DT, A.OPEN_ACCT_TELLER_ID, A.STD_PROD_ID, A.JOB_CD,
               ROW_NUMBER() OVER(PARTITION BY A.CUST_ACCT_ID ORDER BY A.ACCT_ID, A.OPEN_ACCT_TM) AS A_RANK
        FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A --存款分户信息
        /*LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD B
          ON B.CD_ID ='CD1254'  AND B.CD_VAL = A.DEP_ACCT_STATUS_CD*/ --modify by cxl 20220520
        WHERE A.ETL_DT = to_date(V_P_DATE,'yyyymmdd')
          --AND A.SUBJ_ID IN ('20110205', '20110206')  --EAST5.0旧科目
          AND A.SUBJ_ID IN ('20110103', '20110203')  --新一代科目  20110103  对公大额存单 20110203  个人大额存单  LHQ 20221011
          AND (CASE WHEN TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD') IN ('00010101','20991231')
               THEN '20991231'
               ELSE TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD') END)>= V_START_DT
       ) T
     WHERE T.A_RANK = 1
  ) A
  LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B   --内部机构信息
    ON A.BELONG_ORG_ID=B.ORG_ID
    AND B.ETL_DT = to_date(V_P_DATE,'yyyymmdd')
  /*modify by cxl 20220520 更改账户状态从主账户取*/
  LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO C --存款主账户表
    ON A.CUST_ACCT_ID = C.CUST_ACCT_ID
    AND C.ETL_DT = to_date(V_P_DATE,'yyyymmdd')
  LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD F --账户状态
    ON F.CD_VAL = C.ACCT_STATUS_CD
    AND F.CD_ID ='CD1253'
   LEFT JOIN RRP_MDL.CODE_MAP  TA
  ON TA.SRC_VALUE_CODE = C.ACCT_STATUS_CD
  AND TA.SRC_CLASS_CODE = 'CD2544'
  AND TA.TAR_CLASS_CODE = 'D0042'  --介质
  AND TA.MOD_FLG = 'MDM'            --监管集市明细层
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
    SELECT DATA_DT, MED_ID,COUNT(1)
      FROM M_DEP_ACC_MED_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, MED_ID
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

  END ETL_INIT_M_DEP_ACC_MED_INFO;
/

