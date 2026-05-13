CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IBMS_TTRD_OTC_NCD(I_P_DATE IN INTEGER, --跑批日期
                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                 )
 /*******************************************************************
  **存储过程详细说明： 同业存单表
  **存储过程名称：    ETL_O_IOL_IBMS_TTRD_OTC_NCD
  **存储过程创建日期：20220707
  **存储过程创建人：  赖海强
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：           O_ERRCODE
  ** 修改日期    修改人     修改原因
  *  20241226    YJY        优化脚本
  *******************************************************************/
 AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_IBMS_TTRD_OTC_NCD'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  O_ERRCODE := '0';
   SELECT CASE WHEN V_P_DATE = '20191231' THEN TO_DATE('20191231', 'YYYYMMDD')
              WHEN V_P_DATE = '20200630' THEN TO_DATE('20200101', 'YYYYMMDD')
              WHEN V_P_DATE = '20201231' THEN TO_DATE('20200701', 'YYYYMMDD')
              WHEN V_P_DATE = '20210630' THEN TO_DATE('20210101', 'YYYYMMDD')
              WHEN V_P_DATE = '20211231' THEN TO_DATE('20210701', 'YYYYMMDD')
              WHEN V_P_DATE = '20220430' THEN TO_DATE('20220101', 'YYYYMMDD')
              ELSE TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM')
          END INTO V_MONTH_START_DATE
   FROM DUAL;

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_IBMS_TTRD_OTC_NCD';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  
  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-同业存单表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_TTRD_OTC_NCD NOLOGGING
    (I_CODE               --存单代码
    ,A_TYPE               --资产类型
    ,M_TYPE               --市场类型
    ,CURRENCY             --币种
    ,Q_TYPE               --报价方式
    ,B_NAME               --存单名称
    ,P_TYPE               --产品分类
    ,P_CLASS              --产品分类名称
    ,B_COUPON             --利率%、利差BP
    ,NCDCOUNT             --发行量
    ,B_ISSUE_PRICE        --发行价格
    ,MIN_ISSUE_PRICE      --最低发行价格
    ,MAX_ISSUE_PRICE      --最高发行价格
    ,B_START_DATE         --起息日
    ,B_MTR_DATE           --到期日
    ,B_TERM               --期限
    ,FIRST_DATE           --首次利率确定日
    ,B_PAY_FREQ           --付息频率
    ,B_ISSUE_MODE         --发行方式
    ,B_COUPON_TYPE        --息票类型
    ,I_CODE_BENCH         --利率基准
    ,A_TYPE_BENCH         --利率基准
    ,M_TYPE_BENCH         --利率基准
    ,SETTLE_STATUS        --结算状态：0-未结算， 1-部分已结算， 2—已结算
    ,SET_DATE             --缴款日
    ,HONOUR_DATE          --兑付日
    ,B_ISSUE_DATE         --发行日
    ,ANNUAL_RATE	        --年化利率
    ,B_DAYCOUNT	          --计息基准
    ,B_FST_PAY_DATE	      --首次付息日
    ,TENDER_TYPE	        --招标方式 ，0为单一价格招标，1为数量招标
    ,MIN_RATE	            --最低收益率，最低标位参考收益率
    ,MAX_RATE	            --最高收益率，最高标位参考收益率
    ,B_ACTUAL_ISSUE_AMOUNT	  --实际发行量(亿元)
    ,INTORDID	            --内部交易号
    ,ISSUER	              --发行人
    ,ISSUERANGE	          --范围
    ,GRADEINST	          --评级机构
    ,GRADE	              --评级
    ,PARVALUE	            --票面
    ,ISSUE_START_DATE	    --开始发行日期
    ,ISSUE_MTR_DATE	      --结束发行日期
    ,MAX_BID_AMOUNT	      --最大认购量
    ,MIN_BID_AMOUNT	      --最小认购量
    ,SINGE_MAX_BID_AMOUNT	--单笔最大认购量
    ,START_DT	            --开始时间
    ,END_DT	              --结束时间
    ,ID_MARK	            --增删标志
    )
  SELECT /*+PARALLEL*/
     I_CODE               --存单代码
    ,A_TYPE               --资产类型
    ,M_TYPE               --市场类型
    ,CURRENCY             --币种
    ,Q_TYPE               --报价方式
    ,B_NAME               --存单名称
    ,P_TYPE               --产品分类
    ,P_CLASS              --产品分类名称
    ,B_COUPON             --利率%、利差BP
    ,NCDCOUNT             --发行量
    ,B_ISSUE_PRICE        --发行价格
    ,MIN_ISSUE_PRICE      --最低发行价格
    ,MAX_ISSUE_PRICE      --最高发行价格
    ,B_START_DATE         --起息日
    ,B_MTR_DATE           --到期日
    ,B_TERM               --期限
    ,FIRST_DATE           --首次利率确定日
    ,B_PAY_FREQ           --付息频率
    ,B_ISSUE_MODE         --发行方式
    ,B_COUPON_TYPE        --息票类型
    ,I_CODE_BENCH         --利率基准
    ,A_TYPE_BENCH         --利率基准
    ,M_TYPE_BENCH         --利率基准
    ,SETTLE_STATUS        --结算状态：0-未结算， 1-部分已结算， 2—已结算
    ,SET_DATE             --缴款日
    ,HONOUR_DATE          --兑付日
    ,B_ISSUE_DATE         --发行日
    ,ANNUAL_RATE	        --年化利率
    ,B_DAYCOUNT	          --计息基准
    ,B_FST_PAY_DATE	      --首次付息日
    ,TENDER_TYPE	        --招标方式 ，0为单一价格招标，1为数量招标
    ,MIN_RATE	            --最低收益率，最低标位参考收益率
    ,MAX_RATE	            --最高收益率，最高标位参考收益率
    ,B_ACTUAL_ISSUE_AMOUNT	  --实际发行量(亿元)
    ,INTORDID	            --内部交易号
    ,ISSUER	              --发行人
    ,ISSUERANGE	          --范围
    ,GRADEINST	          --评级机构
    ,GRADE	              --评级
    ,PARVALUE	            --票面
    ,ISSUE_START_DATE	    --开始发行日期
    ,ISSUE_MTR_DATE	      --结束发行日期
    ,MAX_BID_AMOUNT	      --最大认购量
    ,MIN_BID_AMOUNT	      --最小认购量
    ,SINGE_MAX_BID_AMOUNT	--单笔最大认购量
    ,START_DT	            --开始时间
    ,END_DT	              --结束时间
    ,ID_MARK	            --增删标志
    FROM IOL.V_IBMS_TTRD_OTC_NCD   --同业存单表_视图
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';
     
     
  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

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


END ETL_O_IOL_IBMS_TTRD_OTC_NCD;
/

