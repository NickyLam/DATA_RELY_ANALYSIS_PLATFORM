CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_CUSTOMER_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：客户基本信息
  **存储过程名称：    ETL_O_IOL_ICMS_CUSTOMER_INFO
  **存储过程创建日期：20251219
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251219    YJY        创建  
  *****************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_ICMS_CUSTOMER_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_CUSTOMER_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-客户基本信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ICMS_CUSTOMER_INFO NOLOGGING 
  (        CUSTOMERID        --客户编号
          ,CERTMATURITY      --证件到期日
          ,MANAGEUSERID      --主办客户经理
          ,INPUTDATE         --登记日期
          ,ISALARMSIGN       --是否预警客户
          ,MFCUSTOMERID      --核心客户号
          ,COMPLETEFLAG      --数据录入完整性标识
          ,CERTCOUNTRY       --证件国别
          ,CERTID            --证件号码
          ,INPUTUSERID       --登记人
          ,STATUS            --状态
          ,ISASSIGN          --是否分配(0未分配1已分配)
          ,MIGTFLAG          --迁移标志：crsrcrilcupl
          ,UPDATEDATE        --更新日期
          ,INPUTORGID        --登记机构
          ,YXCUSTOMERID      --影像客户号
          ,UPDATEORGID       --更新机构
          ,CUSTOMERNAME      --客户名称
          ,CORPORGID         --法人机构编号
          ,ISSELFBIZCUST     --是否自营客户
          ,CERTTYPE          --证件类型
          ,REMARK            --备注
          ,LOANCARDNO        --贷款卡号
          ,CUSTFLAG          --客户标志：BZ-标准对公客户
          ,ISIMPOVERSEE      --是否重点监测客户
          ,MANAGEORGID       --管护机构
          ,ISRELATED         --是否我行关联方
          ,CUSTOMERTYPE      --客户分类
          ,UPDATEUSERID      --更新人
          ,MIGTOLDVALUE      --迁移数据-参数转换前字段值
          ,CUSTOMERTYPELB    --客户类型
          ,START_DT          --开始时间
          ,END_DT            --结束时间
          ,ID_MARK           --增删标志
          ,ETL_TIMESTAMP     --ETL处理时间戳
    )
  SELECT 
           CUSTOMERID        --客户编号
          ,CERTMATURITY      --证件到期日
          ,MANAGEUSERID      --主办客户经理
          ,INPUTDATE         --登记日期
          ,ISALARMSIGN       --是否预警客户
          ,MFCUSTOMERID      --核心客户号
          ,COMPLETEFLAG      --数据录入完整性标识
          ,CERTCOUNTRY       --证件国别
          ,CERTID            --证件号码
          ,INPUTUSERID       --登记人
          ,STATUS            --状态
          ,ISASSIGN          --是否分配(0未分配1已分配)
          ,MIGTFLAG          --迁移标志：crsrcrilcupl
          ,UPDATEDATE        --更新日期
          ,INPUTORGID        --登记机构
          ,YXCUSTOMERID      --影像客户号
          ,UPDATEORGID       --更新机构
          ,CUSTOMERNAME      --客户名称
          ,CORPORGID         --法人机构编号
          ,ISSELFBIZCUST     --是否自营客户
          ,CERTTYPE          --证件类型
          ,REMARK            --备注
          ,LOANCARDNO        --贷款卡号
          ,CUSTFLAG          --客户标志：BZ-标准对公客户
          ,ISIMPOVERSEE      --是否重点监测客户
          ,MANAGEORGID       --管护机构
          ,ISRELATED         --是否我行关联方
          ,CUSTOMERTYPE      --客户分类
          ,UPDATEUSERID      --更新人
          ,MIGTOLDVALUE      --迁移数据-参数转换前字段值
          ,CUSTOMERTYPELB    --客户类型
          ,START_DT          --开始时间
          ,END_DT            --结束时间
          ,ID_MARK           --增删标志
          ,ETL_TIMESTAMP     --ETL处理时间戳
    FROM IOL.V_ICMS_CUSTOMER_INFO --视图-客户基本信息
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ICMS_CUSTOMER_INFO', '', O_ERRCODE); --表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_ICMS_CUSTOMER_INFO;
/

