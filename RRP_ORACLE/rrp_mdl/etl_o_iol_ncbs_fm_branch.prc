CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_NCBS_FM_BRANCH(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：机构信息表
  **存储过程名称：    ETL_O_IOL_NCBS_FM_BRANCH
  **存储过程创建日期：20251210
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251210    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_NCBS_FM_BRANCH'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_NCBS_FM_BRANCH';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-机构信息表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_NCBS_FM_BRANCH NOLOGGING 
  (      AREA_CODE                  --地区码
        ,BRANCH                     --机构编号
        ,BRANCH_NAME                --银行机构名称
        ,COUNTRY                    --国家
        ,PROFIT_CENTER              --利润中心
        ,ABNORMAL_OPEN_CONTROL      --非正常时间开门控制方式
        ,AUTH_FLAG                  --授权标志
        ,BRANCH_SHORT               --机构简称
        ,BRANCH_STATUS              --机构开关门状态
        ,BRANCH_TYPE                --机构类型
        ,CHEQUE_ISSUING_BRANCH_FLAG --是否签发支票
        ,CITY                       --行政区划(城市)
        ,COMPANY                    --法人
        ,DEFAULT_TELLER_LOGIN       --默认柜员登录认证方式
        ,DISTRICT                   --区号
        ,EOD_FLAG                   --日终标识
        ,FTA_CODE                   --自贸区代码
        ,FTA_FLAG                   --是否自贸区机构
        ,FX_ORGAN_CODE              --外汇金融机构代码
        ,INDEX_STR                  --索引字符串
        ,INT_TAX_LEVY               --利息税征收标志
        ,IP_ADDR                    --机构ip地址
        ,OPER_MAX_LEVEL             --操作最高级别
        ,PBOC_FUND_CHECK_FLAG       --人行备付金检查标志
        ,POSTAL_CODE                --邮政编码
        ,STATE                      --行政区划(省、州)
        ,SURTAX_TYPE                --附加税类型
        ,TAILBOX_DETACH_FLAG        --尾箱控制方式
        ,VOUCHER_USER_CONTRAL_FLAG  --是否限制凭证入库柜员
        ,ACCOUNTING_BRANCH          --核算机构
        ,LIBRA_OP_TIME              --libra执行次数
        ,CREATE_DATE                --创建日期
        ,END_DATE                   --结束日期
        ,START_DATE                 --开始日期
        ,TRAN_TIMESTAMP             --交易时间戳
        ,ATTACHED_TO                --所属上级
        ,BASE_CCY                   --基础币种
        ,CCY_CTRL_BRANCH            --结售汇平盘机构
        ,CNY_BUSINESS_UNIT          --账套(人民币)
        ,HIERARCHY_CODE             --机构级别
        ,HKD_BUSINESS_UNIT          --账套(港币)
        ,INTERNAL_CLIENT            --内部客户号
        ,LOCAL_CCY                  --当地币种
        ,SUB_BRANCH_CODE            --分行代码
        ,TAX_RPT_BRANCH             --税收机构（总账用）
        ,TRAN_BR_IND                --是否交易机构
        ,ACCOUNTING_BRANCH_FLAG     --是否核算机构
        ,NORMAL_CLOSE_TIME          --正常关门时间
        ,NORMAL_OPEN_TIME           --正常开门时间
        ,PBOC_FINANCING_NO          --人行金融机构编码
        ,BRANCH_EN_SHORT            --机构英文简称
        ,BRANCH_HEAD_PHONE          --机构负责人联系电话
        ,PBOC_PAY_BRANCH_NO         --人行支付行号
        ,IS_AUTO_CREATE_INTERNAL_ACCT  --是否自动开立内部户
        ,BRANCH_EN_NAME             --机构英文名称
        ,PBOC_AREA_CODE             --人行地区代码
        ,BRANCH_HEAD_NAME           --机构负责人姓名
        ,BRANCH_CLOSE_DATE          --关闭日期
        ,BRANCH_HEAD_DUTY           --机构负责人职务
        ,SWIFT_NO                   --swift号
        ,CUP_FINANCING_NO           --银联金融机构编号
        ,PBOC_ACCT_MANAGE_SYS_NO    --人行账户管理系统行号
        ,START_DT                   --开始时间
        ,END_DT                     --结束时间
        ,ID_MARK                    --增删标志
        ,ETL_TIMESTAMP              --ETL处理时间戳
    )
  SELECT 
         AREA_CODE                  --地区码
        ,BRANCH                     --机构编号
        ,BRANCH_NAME                --银行机构名称
        ,COUNTRY                    --国家
        ,PROFIT_CENTER              --利润中心
        ,ABNORMAL_OPEN_CONTROL      --非正常时间开门控制方式
        ,AUTH_FLAG                  --授权标志
        ,BRANCH_SHORT               --机构简称
        ,BRANCH_STATUS              --机构开关门状态
        ,BRANCH_TYPE                --机构类型
        ,CHEQUE_ISSUING_BRANCH_FLAG --是否签发支票
        ,CITY                       --行政区划(城市)
        ,COMPANY                    --法人
        ,DEFAULT_TELLER_LOGIN       --默认柜员登录认证方式
        ,DISTRICT                   --区号
        ,EOD_FLAG                   --日终标识
        ,FTA_CODE                   --自贸区代码
        ,FTA_FLAG                   --是否自贸区机构
        ,FX_ORGAN_CODE              --外汇金融机构代码
        ,INDEX_STR                  --索引字符串
        ,INT_TAX_LEVY               --利息税征收标志
        ,IP_ADDR                    --机构ip地址
        ,OPER_MAX_LEVEL             --操作最高级别
        ,PBOC_FUND_CHECK_FLAG       --人行备付金检查标志
        ,POSTAL_CODE                --邮政编码
        ,STATE                      --行政区划(省、州)
        ,SURTAX_TYPE                --附加税类型
        ,TAILBOX_DETACH_FLAG        --尾箱控制方式
        ,VOUCHER_USER_CONTRAL_FLAG  --是否限制凭证入库柜员
        ,ACCOUNTING_BRANCH          --核算机构
        ,LIBRA_OP_TIME              --libra执行次数
        ,CREATE_DATE                --创建日期
        ,END_DATE                   --结束日期
        ,START_DATE                 --开始日期
        ,TRAN_TIMESTAMP             --交易时间戳
        ,ATTACHED_TO                --所属上级
        ,BASE_CCY                   --基础币种
        ,CCY_CTRL_BRANCH            --结售汇平盘机构
        ,CNY_BUSINESS_UNIT          --账套(人民币)
        ,HIERARCHY_CODE             --机构级别
        ,HKD_BUSINESS_UNIT          --账套(港币)
        ,INTERNAL_CLIENT            --内部客户号
        ,LOCAL_CCY                  --当地币种
        ,SUB_BRANCH_CODE            --分行代码
        ,TAX_RPT_BRANCH             --税收机构（总账用）
        ,TRAN_BR_IND                --是否交易机构
        ,ACCOUNTING_BRANCH_FLAG     --是否核算机构
        ,NORMAL_CLOSE_TIME          --正常关门时间
        ,NORMAL_OPEN_TIME           --正常开门时间
        ,PBOC_FINANCING_NO          --人行金融机构编码
        ,BRANCH_EN_SHORT            --机构英文简称
        ,BRANCH_HEAD_PHONE          --机构负责人联系电话
        ,PBOC_PAY_BRANCH_NO         --人行支付行号
        ,IS_AUTO_CREATE_INTERNAL_ACCT  --是否自动开立内部户
        ,BRANCH_EN_NAME             --机构英文名称
        ,PBOC_AREA_CODE             --人行地区代码
        ,BRANCH_HEAD_NAME           --机构负责人姓名
        ,BRANCH_CLOSE_DATE          --关闭日期
        ,BRANCH_HEAD_DUTY           --机构负责人职务
        ,SWIFT_NO                   --swift号
        ,CUP_FINANCING_NO           --银联金融机构编号
        ,PBOC_ACCT_MANAGE_SYS_NO    --人行账户管理系统行号
        ,START_DT                   --开始时间
        ,END_DT                     --结束时间
        ,ID_MARK                    --增删标志
        ,ETL_TIMESTAMP              --ETL处理时间戳
    FROM IOL.V_NCBS_FM_BRANCH    --视图-机构信息表
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
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_NCBS_FM_BRANCH', '', O_ERRCODE); --表分析
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

END ETL_O_IOL_NCBS_FM_BRANCH;
/

