CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_FINA_SHEET(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ICMS_FINA_SHEET
  *  功能描述：财报表
  *  创建日期：20220611
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  O_IOL_ICMS_FINA_SHEET
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220611  梅炜     首次创建
  *             2    20250106  YJY      优化脚本
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ICMS_FINA_SHEET'; -- 程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期

   SELECT CASE WHEN I_P_DATE = '20191231' THEN TO_DATE('20191231', 'YYYYMMDD')
              WHEN I_P_DATE = '20200630' THEN TO_DATE('20200101', 'YYYYMMDD')
              WHEN I_P_DATE = '20201231' THEN TO_DATE('20200701', 'YYYYMMDD')
              WHEN I_P_DATE = '20210630' THEN TO_DATE('20210101', 'YYYYMMDD')
              WHEN I_P_DATE = '20211231' THEN TO_DATE('20210701', 'YYYYMMDD')
              WHEN I_P_DATE = '20220430' THEN TO_DATE('20220101', 'YYYYMMDD')
              ELSE TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'), 'MM')
          END INTO V_MONTH_START_DATE
   FROM DUAL;

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM O_IOL_ICMS_FINA_SHEET T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');--普通表的重跑处理
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_FINA_SHEET';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-财报表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_ICMS_FINA_SHEET
  (      SHEETNO			          --报表号
        ,REPORTTYPENO			    --财报类型编号
        ,SHEETTYPE			      --报表类型
        ,REPORTNO			        --财报号
        ,CUSTOMERID			      --客户编号
        ,ACCOUNTINGMONTH			--会计月
        ,REPORTSCOPE			    --报表口径
        ,REPORTPERIOD			    --报表周期
        ,DELETEFLAG			      --删除标志
        ,CALCULATEERRORINFO		--计算错误信息
        ,INPUTUSERID			    --登记人
        ,INPUTORGID			      --登记机构
        ,INPUTDATE			      --登记日期
        ,UPDATEUSERID			    --更新人
        ,UPDATEORGID			    --更新机构
        ,UPDATEDATE			      --更新日期
        ,REPORTNAME			      --报表名称
        ,START_DT			        --起始日期
        ,END_DT			          --截止日期
        ,ID_MARK			        --增删标志
     )
     SELECT
        SHEETNO			          --报表号
        ,REPORTTYPENO			    --财报类型编号
        ,SHEETTYPE			      --报表类型
        ,REPORTNO			        --财报号
        ,CUSTOMERID			      --客户编号
        ,ACCOUNTINGMONTH			--会计月
        ,REPORTSCOPE			    --报表口径
        ,REPORTPERIOD			    --报表周期
        ,DELETEFLAG			      --删除标志
        ,CALCULATEERRORINFO		--计算错误信息
        ,INPUTUSERID			    --登记人
        ,INPUTORGID			      --登记机构
        ,INPUTDATE			      --登记日期
        ,UPDATEUSERID			    --更新人
        ,UPDATEORGID			    --更新机构
        ,UPDATEDATE			      --更新日期
        ,REPORTNAME			      --报表名称
        ,START_DT			        --起始日期
        ,END_DT			          --截止日期
        ,ID_MARK			        --增删标志
    FROM IOL.V_ICMS_FINA_SHEET  --财报表
    WHERE ID_MARK <> 'D'
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;

  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ICMS_FINA_SHEET', '', O_ERRCODE); --表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_O_IOL_ICMS_FINA_SHEET;
/

