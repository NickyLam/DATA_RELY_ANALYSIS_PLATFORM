CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_PAMS_JXDX_LCZH(I_P_DATE IN INTEGER,
                                                                         O_ERRCODE OUT VARCHAR2
                                                                         )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_PAMS_JXDX_LCZH
  *  功能描述：绩效对象-理财账户
  *  创建日期：20241028
  *  开发人员：YJY
  *  来源表： IOL.V_PAMS_JXDX_LCZH
  *  目标表： O_IOL_PAMS_JXDX_LCZH
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20241028  YJY      首次创建
  **********************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_PAMS_JXDX_LCZH'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IOL_PAMS_JXDX_LCZH T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_PAMS_JXDX_LCZH';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-绩效对象-理财账户';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_PAMS_JXDX_LCZH
    (
     JXDXDH                 --绩效对象代号 
    ,ZHDH                   --账号         
    ,ZHHM                   --账户户名     
    ,BZ                     --币种         
    ,JGDH                   --机构代号     
    ,KMH                    --科目号       
    ,KHRQ                   --开户日期     
    ,XHRQ                   --销户日期     
    ,CPDM                   --产品代码     
    ,CPLB                   --产品类别     
    ,CPMC                   --产品名称     
    ,MJKSR                  --募集开始日   
    ,MJJSR                  --募集结束日   
    ,NLL                    --年利率       
    ,ZHYE                   --账户余额     
    ,ZHBS                   --账户标识     
    ,ZHZT                   --账户状态     
    ,GXHSLX                 --关系函数类型 
    ,KHDXDH                 --考核对象代号 
    ,KHH                    --客户号       
    ,HYDH                   --行员代号     
    ,TJRQ                   --统计日期     
    ,QXRQ                   --起息日期     
    ,ZXRQ                   --注销日期     
    ,YQNHSYL                --年化收益率   
    ,CPYZSJ                 --产品运作时间 
    ,MRJEHZ                 --买入金额汇总 
    ,CYFE                   --持有份额     
    ,MJJE                   --募集金额     
    ,ZJJSZH                 --资金结算账户 
    ,XSSDM                  --销售商代码   
    ,YHBH                   --银行编号     
    ,ZHBH                   --账户编号     
    ,START_DT               --开始时间     
    ,END_DT                 --结束时间     
    ,ID_MARK                --增删标志     
    ,ETL_TIMESTAMP          --ETL处理时间戳
    )
  SELECT  
     JXDXDH                 --绩效对象代号 
    ,ZHDH                   --账号         
    ,ZHHM                   --账户户名     
    ,BZ                     --币种         
    ,JGDH                   --机构代号     
    ,KMH                    --科目号       
    ,KHRQ                   --开户日期     
    ,XHRQ                   --销户日期     
    ,CPDM                   --产品代码     
    ,CPLB                   --产品类别     
    ,CPMC                   --产品名称     
    ,MJKSR                  --募集开始日   
    ,MJJSR                  --募集结束日   
    ,NLL                    --年利率       
    ,ZHYE                   --账户余额     
    ,ZHBS                   --账户标识     
    ,ZHZT                   --账户状态     
    ,GXHSLX                 --关系函数类型 
    ,KHDXDH                 --考核对象代号 
    ,KHH                    --客户号       
    ,HYDH                   --行员代号     
    ,TJRQ                   --统计日期     
    ,QXRQ                   --起息日期     
    ,ZXRQ                   --注销日期     
    ,YQNHSYL                --年化收益率   
    ,CPYZSJ                 --产品运作时间 
    ,MRJEHZ                 --买入金额汇总 
    ,CYFE                   --持有份额     
    ,MJJE                   --募集金额     
    ,ZJJSZH                 --资金结算账户 
    ,XSSDM                  --销售商代码   
    ,YHBH                   --银行编号     
    ,ZHBH                   --账户编号     
    ,START_DT               --开始时间     
    ,END_DT                 --结束时间     
    ,ID_MARK                --增删标志     
    ,ETL_TIMESTAMP          --ETL处理时间戳
    FROM IOL.V_PAMS_JXDX_LCZH  --视图-绩效对象-理财账户
   WHERE ID_MARK <> 'D'
     AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
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

END ETL_O_IOL_PAMS_JXDX_LCZH;
/

