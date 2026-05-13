CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_PAMS_JXBB_XWQYDKMXB(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_PAMS_JXBB_XWQYDKMXB
  *  功能描述：小微企业贷款明细表
  *  创建日期：20240612
  *  开发人员：LYH
  *  来源表：
  *  目标表： O_IOL_PAMS_JXBB_XWQYDKMXB
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240612  LYH     首次创建
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP          INTEGER      := 0;                               --处理步骤
  V_PROC_NAME     VARCHAR2(50) := 'ETL_O_IOL_PAMS_JXBB_XWQYDKMXB'; --程序名称
  V_TAB_NAME      VARCHAR2(100):= 'O_IOL_PAMS_JXBB_XWQYDKMXB';     --表名
  V_P_DATE        VARCHAR2(8);                                     --跑批数据日期
  V_STARTTIME     DATE;                                            --处理开始时间
  V_ENDTIME       DATE;                                            --处理结束时间
  V_SQLCOUNT      INTEGER := 0;                                    --更新或删除影响的记录数
  V_SQLMSG        VARCHAR2(300);                                   --SQL执行描述信息
  V_STEP_DESC     VARCHAR2(200);                                   --任务名称
  V_PART_NAME     VARCHAR2(200);                                   --分区名
  V_SYSTEM        VARCHAR2(30) := '监管报送';                      --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE    := TO_CHAR( I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

  --DELETE FROM O_IOL_PAMS_JXBB_XWQYDKMXB T WHERE  T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE O_IOL_PAMS_JXBB_XWQYDKMXB';
  --EXECUTE IMMEDIATE ('ALTER TABLE '||V_TAB_NAME||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-小微企业贷款明细表';
  V_STARTTIME := SYSDATE;
  INSERT /*+ append */ INTO RRP_MDL.O_IOL_PAMS_JXBB_XWQYDKMXB
    (TJRQ          --01统计日期
    ,JXDXDH        --02绩效对象代号
    ,JGKHDXDH      --03机构考核对象代号
    ,JGDH          --04机构代号
    ,JGMC          --05机构名称
    ,JJH           --06借据号
    ,KHH           --07客户号
    ,KHMC          --08客户名称
    ,DKLX          --09贷款类型
    ,SFXW          --10是否小微标识
    ,YWPZ          --11业务配置
    ,KMH           --12科目号
    ,KMMC          --13科目名称
    ,FFRQ          --14发放日期
    ,DQRQ          --15到期日期
    ,BZZWMC        --16币种
    ,DKJE          --17贷款金额
    ,ZCYE          --18正常余额
    ,ZCYRJ         --19正常月日均
    ,ZCJRJ         --20正常季日均
    ,ZCNRJ         --21正常年日均
    ,YQYE          --22逾期余额
    ,YQYRJ         --23逾期月日均
    ,YQJRJ         --24逾期季日均
    ,YQNRJ         --25逾期年日均
    ,NLL           --26年利率
    ,JZLL          --27基准利率
    ,KHDXDH        --28考核对象代号
    ,HYDH          --29客户经理工号
    ,HYMC          --30客户经理名称
    ,SSJGKHDXDH    --31所属机构考核对象代号
    ,SSJGDH        --32所属机构号
    ,SSJGMC        --33所属机构名称
    ,FPJE          --34分配总金额
    ,ZLBL          --35分配比例
    ,FPHZCYE       --36分配后正常余额
    ,FPHZCYRJ      --37分配后正常月日均
    ,FPHZCJRJ      --38分配后正常季日均
    ,FPHZCNRJ      --39分配后正常年日均
    ,FPHYQYE       --40分配后逾期余额
    ,FPHYQYRJ      --41分配后逾期月日均
    ,FPHYQJRJ      --42分配后逾期季日均
    ,FPHYQNRJ      --43分配后逾期年日均
    ,ETL_DT        --44ETL处理日期
    )
  SELECT TJRQ          --01统计日期
        ,JXDXDH        --02绩效对象代号
        ,JGKHDXDH      --03机构考核对象代号
        ,JGDH          --04机构代号
        ,JGMC          --05机构名称
        ,JJH           --06借据号
        ,KHH           --07客户号
        ,KHMC          --08客户名称
        ,DKLX          --09贷款类型
        ,SFXW          --10是否小微标识
        ,YWPZ          --11业务配置
        ,KMH           --12科目号
        ,KMMC          --13科目名称
        ,FFRQ          --14发放日期
        ,DQRQ          --15到期日期
        ,BZZWMC        --16币种
        ,DKJE          --17贷款金额
        ,ZCYE          --18正常余额
        ,ZCYRJ         --19正常月日均
        ,ZCJRJ         --20正常季日均
        ,ZCNRJ         --21正常年日均
        ,YQYE          --22逾期余额
        ,YQYRJ         --23逾期月日均
        ,YQJRJ         --24逾期季日均
        ,YQNRJ         --25逾期年日均
        ,NLL           --26年利率
        ,JZLL          --27基准利率
        ,KHDXDH        --28考核对象代号
        ,HYDH          --29客户经理工号
        ,HYMC          --30客户经理名称
        ,SSJGKHDXDH    --31所属机构考核对象代号
        ,SSJGDH        --32所属机构号
        ,SSJGMC        --33所属机构名称
        ,FPJE          --34分配总金额
        ,ZLBL          --35分配比例
        ,FPHZCYE       --36分配后正常余额
        ,FPHZCYRJ      --37分配后正常月日均
        ,FPHZCJRJ      --38分配后正常季日均
        ,FPHZCNRJ      --39分配后正常年日均
        ,FPHYQYE       --40分配后逾期余额
        ,FPHYQYRJ      --41分配后逾期月日均
        ,FPHYQJRJ      --42分配后逾期季日均
        ,FPHYQNRJ      --43分配后逾期年日均
        ,ETL_DT        --44ETL处理日期
    FROM IOL.V_PAMS_JXBB_XWQYDKMXB --视图-小微企业贷款明细表
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

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

END ETL_O_IOL_PAMS_JXBB_XWQYDKMXB;
/

