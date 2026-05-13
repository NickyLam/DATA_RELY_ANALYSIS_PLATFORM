CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_LOAN_A3326(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_LOAN_A3326
  *  功能描述：A3326明细结果表
  *  创建日期：20230206
  *  开发人员：黄一凡
  *  来源表：   S_LOAN
  *  目标表：   S_LOAN_A3326
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *            1    20230206   黄一凡   新增
  *  特殊说明：与刘娉婷沟通后口径说明：
  *  1、其中：农林牧渔业贷款:只有四种产品 商易贷（佛山正邦）、商易贷（双胞胎）、“恒兴股份个人经营贷”、“粤海饲料个人经营贷”。
  *  2、以刘娉婷提供的底稿数据为基准，底稿数据均报精准扶贫，后面有新增的按照扶贫名单匹配，满足条件则报送
  **********************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_LOAN_A3326'; -- 程序名称
  V_TABLE_NAME VARCHAR2(30) := 'S_LOAN_A3326'; -- 表名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_YESTADAY  VARCHAR2(8); -- 上日
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_PART_NAME VARCHAR2(100);   --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_MONTH_START_DATE := TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM');
  V_PART_NAME := 'PARTITION_'||V_YESTADAY;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_LOAN_A3326 T WHERE T.SJRQ = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||V_TABLE_NAME||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
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
  ETL_PARTITION_ADD(V_YESTADAY, V_TABLE_NAME, '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  EXECUTE IMMEDIATE ('ALTER TABLE '||V_TABLE_NAME||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

 ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := 'A3326明细结果表--加工A3326明细结果表底稿0630数据';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO S_LOAN_A3326 NOLOGGING
  (
    SJRQ,--数据日期
    SSZWJG,--所属账务机构
    KHBH,--客户编号
    DKJJBH,--贷款借据编号
    BZCPBH,--标准产品编号
    BZ,--币种
    DKFFJE,--贷款发放金额
    DKJZ,--贷款净值
    DKJJFFR,--贷款借据发放日
    DKYT,--贷款用途
    DKYWPZ,--贷款业务品种
    FXPJWJ,--风险评级五级
    DBFS,--担保方式
    TPZT,--脱贫状态
    DKTXHYML,--贷款投向行业门类
    QXLX,--期限类型
    XFJYBZ,--消费经营标志
    SFYWCSMX, --是否业务提供初始明细
    SJLY --数据来源
  )

  SELECT /*+ USE_HASH(A B)  PARALLEL(4)*/
        V_YESTADAY AS  SJRQ,--数据日期
        A.ORG_ID AS SSZWJG,--所属账务机构
        A.CUST_ID AS KHBH,--客户编号
        A.RCPT_ID AS DKJJBH,--贷款借据编号
        A.STD_PROD_ID AS BZCPBH,--标准产品编号
        A.CUR AS BZ,--币种
        A.LOAN_AMT AS DKFFJE,--贷款发放金额
        A.LOAN_NET_VAL AS DKJZ,--贷款净值
        A.LOAN_ACT_DSTR_DT AS DKJJFFR,--贷款借据发放日
        A.LOAN_USEAGE AS DKYT,--贷款用途
        A.LOAN_BIZ_TYP AS DKYWPZ,--贷款业务品种
        A.LVL5_CL AS FXPJWJ,--风险评级五级
        A.TJDBFS AS DBFS,--担保方式
        CASE WHEN B.TPZT IN ('返贫','未脱贫') THEN 'N' ELSE 'Y' END  AS TPZT,--脱贫状态
        CASE WHEN A.STD_PROD_ID IN ('201020100009','201020100016','201020100024','201020100014') THEN 'A'
        ELSE '' END AS DKTXHYML, --贷款投向行业门类
        A.LOAN_TERM AS QXLX,--期限类型
        CASE WHEN SUBSTR(A.LOAN_BIZ_TYP,1,4) = '0102' THEN 'JY'
             WHEN SUBSTR(A.LOAN_BIZ_TYP,1,4) IN ('0101','0103','0104') THEN 'XF'
        ELSE ''  END AS XFJYBZ,--消费经营标志
        'Y'  AS SFYWCSMX,--是否业务提供初始明细
        A.DATA_SRC AS SJLY--数据来源
  FROM RRP_MDL.S_LOAN A --贷款业务整合表
  INNER JOIN RRP_MDL.S_A3326_BASE_DATA B --A3326基础明细表
          ON A.RCPT_ID = B.DKJJBH    --借据号
  WHERE A.DATA_DT = V_YESTADAY
  ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_LOAN字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  V_STEP := 4;
  V_STEP_DESC := 'A3326明细结果表--加工20220701之后发放的明细';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO S_LOAN_A3326 NOLOGGING
  (
    SJRQ,--数据日期
    SSZWJG,--所属账务机构
    KHBH,--客户编号
    DKJJBH,--贷款借据编号
    BZCPBH,--标准产品编号
    BZ,--币种
    DKFFJE,--贷款发放金额
    DKJZ,--贷款净值
    DKJJFFR,--贷款借据发放日
    DKYT,--贷款用途
    DKYWPZ,--贷款业务品种
    FXPJWJ,--风险评级五级
    DBFS,--担保方式
    TPZT,--脱贫状态
    DKTXHYML,--贷款投向行业门类
    QXLX,--期限类型
    XFJYBZ,--消费经营标志
    SFYWCSMX, --是否业务提供初始明细
    SJLY --数据来源
  )
 SELECT /*+ USE_HASH(A B)  PARALLEL(4)*/
        V_YESTADAY AS  SJRQ,--数据日期
        A.ORG_ID AS SSZWJG,--所属账务机构
        A.CUST_ID AS KHBH,--客户编号
        A.RCPT_ID AS DKJJBH,--贷款借据编号
        A.STD_PROD_ID AS BZCPBH,--标准产品编号
        A.CUR AS BZ,--币种
        A.LOAN_AMT AS DKFFJE,--贷款发放金额
        A.LOAN_NET_VAL AS DKJZ,--贷款净值
        A.DSBR_DT AS DKJJFFR,--贷款借据发放日
        A.LOAN_USEAGE AS DKYT,--贷款用途
        A.LOAN_BIZ_TYP AS DKYWPZ,--贷款业务品种
        A.LVL5_CL AS FXPJWJ,--风险评级五级
        A.MAIN_GUA_MODE AS DBFS,--担保方式
        CASE WHEN A.REC_POOR_PSN_LOAN_TYP = '201' THEN 'Y' ELSE 'N' END  AS TPZT,--脱贫状态 101-未脱贫 201-脱贫
        CASE WHEN A.STD_PROD_ID IN ('201020100009','201020100016','201020100024','201020100014') THEN 'A'
        ELSE '' END AS DKTXHYML, --贷款投向行业门类
        A.LOAN_TERM AS QXLX,--期限类型
        CASE WHEN SUBSTR(A.LOAN_BIZ_TYP,1,4) = '0102' THEN 'JY'
             WHEN SUBSTR(A.LOAN_BIZ_TYP,1,4) IN ('0101','0103','0104') THEN 'XF'
        ELSE ''  END AS XFJYBZ,--消费经营标志
        'N'  AS SFYWCSMX,--是否业务提供初始明细
        A.DATA_SRC AS SJLY--数据来源
  FROM RRP_MDL.S_LOAN_POV_ALLE A --金融精准扶贫整合表
  WHERE A.DATA_DT = V_YESTADAY
   AND A.REC_POOR_PSN_LOAN_TYP IN ('101','201') --取已脱贫及未脱贫数据
   AND TO_DATE(A.DSBR_DT,'YYYYMMDD') >= TO_DATE('20220701','YYYYMMDD') --取20220701新发放的数据
   AND A.CUR = 'CNY'
   ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_LOAN字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
    INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;

   -- 程序跑批结束记录 --
   V_STEP := V_STEP + 1;
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
    -- V_STEP := V_STEP + 1;
    -- V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_S_LOAN_A3326;
/

