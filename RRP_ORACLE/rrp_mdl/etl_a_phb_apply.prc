CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_PHB_APPLY
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
/**************************************************************************
  *  程序名称：ETL_A_PHB_APPLY
  *  功能描述：零售-申请客户小基表
  *  创建日期：20221107
  *  开发人员：WYX
  *  来源表：
  *  目标表：A_PHB_APPLY           --零售-申请客户小基表
  *  配置表：
  *  修改情况：
     序号  修改日期   修改人    修改原因
  *   1    20221031   WYX       首次创建
      2    20230424   liuyu     加入当年放款部分去重
      3    20230504   liuyu     剔除对公数据
      4    20250411   HYF       申请编号拼接后缀防止同借据号数据重复      
***************************************************************************/
 AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_PHB_APPLY';   --程序名称
  V_P_DATE     VARCHAR2(8);      -- 跑批数据日期
  V_DATE       DATE;
  V_STARTTIME  DATE;             -- 处理开始时间
  V_ENDTIME    DATE;             -- 处理结束时间
  V_SQLCOUNT   INTEGER := 0;     -- 更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);    -- SQL执行描述信息
  V_SYSTEM     VARCHAR2(30);     -- 来源系统
  V_STEP_DESC  VARCHAR2(200);    --任务名称
  V_TAB_NAME VARCHAR2(100) ; --表名
  V_PART_NAME VARCHAR2(100); --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE     := TO_CHAR(I_P_DATE);  -- 获取跑批日期
  V_DATE       := TO_DATE(I_P_DATE,'YYYYMMDD'); --时间格式
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME   := 'A_PHB_APPLY'; --表名,写目标表表名
  V_PART_NAME  := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT  := SQL%ROWCOUNT;
  V_SQLMSG    := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE   := '0';
  V_ENDTIME   := SYSDATE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
   V_STEP := V_STEP + 1;
   V_STEP_DESC := '分区处理';
   V_STARTTIME := SYSDATE;

   ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '1', O_ERRCODE);

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '零售-申请流水部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO A_PHB_APPLY
    (
        BGRQ         --报告日期
       ,SQBH         --申请编号
       ,SQRQ         --申请日期
       ,ZWJGBH       --账务机构编号
       ,ZWJGMC       --账务机构名称
       ,SQKHMC       --申请客户名称
       ,SQKHZJHM     --申请客户证件号码
       ,TJYWPZ       --统计业务品种
       ,GRKHATJFL    --个人客户按统计分类
       ,SQKHWYM      --申请客户唯一码
       ,DEPARTMENTD  --归属部门
       ,SQYWPZ       --申请业务品种
       ,BZCPBH       --标准产品编号
    )
    SELECT A.DATA_DT         AS BGRQ      --报告日期
          ,A.APP_ID||'_SQ'   AS SQBH      --申请编号
          ,A.APP_DT          AS SQRQ      --申请日期
          ,A.ORG_ID          AS ZWJGBH    --账务机构编号
          ,E.ORG_NM          AS ZWJGMC    --账务机构名称
          ,D.CUST_NM         AS SQKHMC    --申请客户名称
          ,A.CRDL_NO         AS SQKHZJHM  --申请客户证件号码
           -- 申请流水中有不在行内开户的客户，取申请流水的证件号
          ,NVL(C2.LEVEL3_PROD_NAME,C.LEVEL3_PROD_NAME)
                             AS TJYWPZ    --统计业务品种
          ,DECODE(A.OPR_CUST_TYP,'B','小微企业主','A','个体工商户','不适用')
                             AS GRKHATJFL --个人客户按统计分类 --码值编号 C0067
          ,A.CUST_ID         AS SQKHWYM   --申请客户唯一码
          ,A.DATA_SRC||'申请流水'        AS DEPARTMENTD --归属部门
          ,COALESCE(C2.PROD_NAME,C.PROD_NAME,C1.PROD_NAME)
                             AS SQYWPZ    --申请业务品种
          ,A.STD_PROD_ID     AS BZCPBH    --标准产品编号
      FROM RRP_MDL.S_LOAN_APP A --贷款申请信息整合表
      LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO C --标准产品信息表
        ON C.PROD_ID = A.LOAN_BIZ_TYP
       AND C.ETL_DT = V_DATE
      LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO C2 --标准产品信息表
        ON C2.PROD_ID = A.STD_PROD_ID
       AND C2.ETL_DT = V_DATE
      LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_PROD_INFO C1 --贷款产品信息表
        ON C1.PROD_ID = A.LOAN_BIZ_TYP
       AND C1.ETL_DT = V_DATE
      LEFT JOIN RRP_MDL.M_CUST_IND_INFO D --个人客户信息
        ON D.CUST_ID = A.CUST_ID
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO E --机构表
        ON E.ORG_ID = A.ORG_ID
       AND E.DATA_DT = V_P_DATE
     WHERE A.DATA_DT = V_P_DATE
       AND A.DATA_SRC IN ('零售贷款','联合网贷') --MOD BY LIUYU 20230504
       ;
   COMMIT;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '零售-当年放款部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO A_PHB_APPLY
    (
        BGRQ         --报告日期
       ,SQBH         --申请编号
       ,SQRQ         --申请日期
       ,ZWJGBH       --账务机构编号
       ,ZWJGMC       --账务机构名称
       ,SQKHMC       --申请客户名称
       ,SQKHZJHM     --申请客户证件号码
       ,TJYWPZ       --统计业务品种
       ,GRKHATJFL    --个人客户按统计分类
       ,SQKHWYM      --申请客户唯一码
       ,DEPARTMENTD  --归属部门
       ,SQYWPZ       --申请业务品种
       ,BZCPBH       --标准产品编号
    )
    SELECT A.DATA_DT         AS BGRQ      --报告日期
          ,A.RCPT_ID         AS SQBH      --申请编号
          ,B.LOAN_ACT_DSTR_DT
                             AS SQRQ      --申请日期
           -- S_LOAN 把 1231放款的改为 0101 放款所以基表不会出现0101放款借据
          ,A.ORG_ID          AS ZWJGBH    --账务机构编号
          ,E.ORG_NM          AS ZWJGMC    --账务机构名称
          ,D.CUST_NM         AS SQKHMC    --申请客户名称
          ,D.CRDL_NO         AS SQKHZJHM  --申请客户证件号码
          ,C.LEVEL3_PROD_NAME
                             AS TJYWPZ    --统计业务品种
          ,DECODE(A.OPR_CUST_TYP,'B','小微企业主','A','个体工商户','不适用')
                             AS GRKHATJFL --个人客户按统计分类 --码值编号 C0067
          ,A.CUST_ID         AS SQKHWYM   --申请客户唯一码
          ,A.DATA_SRC||'借据放款'        AS DEPARTMENTD --归属部门
          ,C.PROD_NAME       AS SQYWPZ    --申请业务品种
          ,A.STD_PROD_ID     AS BZCPBH    --标准产品编号
      FROM RRP_MDL.S_LOAN A --贷款业务整合表
      LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO B --表内借据信息
        ON B.RCPT_ID = A.RCPT_ID
       AND B.DATA_DT = A.DATA_DT
       AND B.DATA_SRC = A.DATA_SRC
      LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO C --标准产品信息表
        ON C.PROD_ID = A.STD_PROD_ID
       AND C.ETL_DT = V_DATE
      LEFT JOIN M_CUST_IND_INFO D --个人客户信息
        ON D.CUST_ID = A.CUST_ID
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN M_PUM_ORG_INFO E --机构表
        ON E.ORG_ID = A.ORG_ID
       AND E.DATA_DT = V_P_DATE
     WHERE A.DATA_DT = V_P_DATE
       AND A.LOAN_BIZ_TYP LIKE '0102%' -- 只要个人经营贷款
       AND A.DATA_SRC IN ('零售贷款','联合网贷')
       AND (SUBSTR(A.LOAN_ACT_DSTR_DT,1,4) =  SUBSTR(V_P_DATE,1,4)
         OR (A.DATA_SRC='联合网贷' AND A.LOAN_ACT_DSTR_DT=TO_CHAR(TO_DATE(SUBSTR(V_P_DATE,1,4)||'0101','YYYYMMDD')-1,'YYYYMMDD'))
             )
               --放款日期为本年
       --S_LOAN 把 1231放款的改为 0101 放款所以基表不会出现0101放款借据
       ;
   COMMIT;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 数据重复校验 --
  WITH TMP1 AS (
    SELECT BGRQ,SQBH,COUNT(1)
      FROM RRP_MDL.A_PHB_APPLY T
     WHERE BGRQ = V_P_DATE
     GROUP BY BGRQ,SQBH
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  --插入过程跑批完成记录表
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
     V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_A_PHB_APPLY;
/

