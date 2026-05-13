CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_NOAS_OA_STOCKHOLDER_INFO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_NOAS_OA_STOCKHOLDER_INFO
  *  功能描述：客户股东信息
  *  创建日期：20220820
  *  开发人员：梅炜
  *  来源表： IML.V_AGT_ABS_AMT_DTL_SPLT_H
  *  目标表： O_IOL_NOAS_OA_STOCKHOLDER_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  *             2    20250107  YJY      优化脚本
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_NOAS_OA_STOCKHOLDER_INFO'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM O_IOL_NOAS_OA_STOCKHOLDER_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_NOAS_OA_STOCKHOLDER_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-客户股东信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_NOAS_OA_STOCKHOLDER_INFO
  (
          STOCK_INFO_ID                   --主键ID
          ,STOCKHOLDER_ID                 --股东编号
          ,STOCKHOLDER_NAME               --股东名称
          ,CERTIFICATE_TYPE               --证件类型
          ,CERTIFICATE_CODE               --证件号码
          ,ORGANIZATION_CODE              --组织机构代码
          ,STOCKHOLDER_TYPE               --股东类型
          ,STOCKHOLDER_PROPERTY           --股权性质
          ,STOCK_OWN_AMOUNT               --持股数量
          ,STOCK_LIMIT_AMOUNT             --限售股数
          ,STOCK_PLEDGE_AMOUNT            --质押股数
          ,STOCK_FREEZE_AMOUNT            --冻结股数
          ,ADDRESS                        --具体住所
          ,POST_CODE                      --邮编
          ,LINKMAN                        --联系人
          ,PHONE                          --电话
          ,STOCK_CERTIFICATE_CODE         --股权证编号
          ,INTEREST_ACCOUNT               --派息账户账号
          ,INTEREST_ACCOUNT_NAME          --派息账户户名
          ,INTEREST_ACCOUNT_BANK          --派息账户开户行
          ,STOCKHOLDER_BEGIN_DATE         --成为本行股东日期
          ,STOCKHOLDER_END_DATE           --终止成为本行股东日期
          ,IS_PRIVILLEGE_MAKE_SURE        --是否确权
          ,STATUS                         --状态
          ,LAST_UPDATED_STAMP             --BOSENT自带最后修改时间
          ,LAST_UPDATED_TX_STAMP          --BOSENT自带最后修改时间
          ,CREATED_STAMP                  --BOSENT自带创建时间
          ,CREATED_TX_STAMP               --BOSENT自带创建时间
          --,SHAREHODER_NEEW_NAME  --未知
          ,DOMINANT_STOCKHOLDER           --是否为控股股东
          ,NATIONAL_ECONOMY_CODE          --国民经济行业代码
          ,NATURE_OF_OWNERSHIP            --所有制性质
          ,FINAL_BENEFICIARY              --最终受益人
          ,ACTUAL_CONTROLLER              --实际控制人
          ,HOLDING_ORGANIZATION           --实际控制人管理机构
          ,INDIRECTOR                     --是否派驻董监高
          ,CONTROLLER_RATIO               --实际控制人及一致行动人持股比例
          ,MAIN_STOCKHOLDER               --是否主要股东
          ,STOCK_STATISTIC_TYPE           --G07报表股东类型
          ,EAST_STOCKHOLDER_TYPE          --EAST股东或关联方类型
          ,STOCKHOLDER_CERTIFICATE_TYPE   --EAST股东或关联方证件类别
          ,STOCKHOLDER_REGISTRATION_PLACE --EAST股东或关联方注册地
          ,STOCKHOLDER_SHARE_BANK_AMOUNT  --EAST作为主要股东参股商业银行的数量
          ,STOCKHOLDER_HOLD_BANK_AMOUNT   --EAST作为主要股东控股商业银行的数量
          ,BAD_INFORMATION                --EAST不良信息
          ,IS_POWER_RESTRAINT             --EAST是否限权
          ,CAPITAL_SOURCE                 --EAST入股资金来源
          ,FUND_ACCOUNT                   --EAST入股资金账号
          ,PLEDGE_PROPORTION              --EAST质押比例
          ,LAST_TIME_CHANGE_DATE          --EAST最近一次变动日期
          ,EAST_REMARK                    --EAST备注
          ,FOREIGN_STOCKHOLDER            --G08外资股东
          ,NATIONALITY                    --G08国别(地区)
          --,PARENT_COMPANY_PLACE         --G08母公司所在国家(地区)
          ,START_DT                       --开始时间
          ,END_DT                         --结束时间
          ,ID_MARK                        --增删标志
          ,ETL_TIMESTAMP                  --ETL处理时间戳
    )
    SELECT
					STOCK_INFO_ID                   --主键ID
          ,STOCKHOLDER_ID                 --股东编号
          ,STOCKHOLDER_NAME               --股东名称
          ,CERTIFICATE_TYPE               --证件类型
          ,CERTIFICATE_CODE               --证件号码
          ,ORGANIZATION_CODE              --组织机构代码
          ,STOCKHOLDER_TYPE               --股东类型
          ,STOCKHOLDER_PROPERTY           --股权性质
          ,STOCK_OWN_AMOUNT               --持股数量
          ,STOCK_LIMIT_AMOUNT             --限售股数
          ,STOCK_PLEDGE_AMOUNT            --质押股数
          ,STOCK_FREEZE_AMOUNT            --冻结股数
          ,ADDRESS                        --具体住所
          ,POST_CODE                      --邮编
          ,LINKMAN                        --联系人
          ,PHONE                          --电话
          ,STOCK_CERTIFICATE_CODE         --股权证编号
          ,INTEREST_ACCOUNT               --派息账户账号
          ,INTEREST_ACCOUNT_NAME          --派息账户户名
          ,INTEREST_ACCOUNT_BANK          --派息账户开户行
          ,STOCKHOLDER_BEGIN_DATE         --成为本行股东日期
          ,STOCKHOLDER_END_DATE           --终止成为本行股东日期
          ,IS_PRIVILLEGE_MAKE_SURE        --是否确权
          ,STATUS                         --状态
          ,LAST_UPDATED_STAMP             --BOSENT自带最后修改时间
          ,LAST_UPDATED_TX_STAMP          --BOSENT自带最后修改时间
          ,CREATED_STAMP                  --BOSENT自带创建时间
          ,CREATED_TX_STAMP               --BOSENT自带创建时间
          --,SHAREHODER_NEEW_NAME  --未知
          ,DOMINANT_STOCKHOLDER           --是否为控股股东
          ,NATIONAL_ECONOMY_CODE          --国民经济行业代码
          ,NATURE_OF_OWNERSHIP            --所有制性质
          ,FINAL_BENEFICIARY              --最终受益人
          ,ACTUAL_CONTROLLER              --实际控制人
          ,HOLDING_ORGANIZATION           --实际控制人管理机构
          ,INDIRECTOR                     --是否派驻董监高
          ,CONTROLLER_RATIO               --实际控制人及一致行动人持股比例
          ,MAIN_STOCKHOLDER               --是否主要股东
          ,STOCK_STATISTIC_TYPE           --G07报表股东类型
          ,EAST_STOCKHOLDER_TYPE          --EAST股东或关联方类型
          ,STOCKHOLDER_CERTIFICATE_TYPE   --EAST股东或关联方证件类别
          ,STOCKHOLDER_REGISTRATION_PLACE --EAST股东或关联方注册地
          ,STOCKHOLDER_SHARE_BANK_AMOUNT  --EAST作为主要股东参股商业银行的数量
          ,STOCKHOLDER_HOLD_BANK_AMOUNT   --EAST作为主要股东控股商业银行的数量
          ,BAD_INFORMATION                --EAST不良信息
          ,IS_POWER_RESTRAINT             --EAST是否限权
          ,CAPITAL_SOURCE                 --EAST入股资金来源
          ,FUND_ACCOUNT                   --EAST入股资金账号
          ,PLEDGE_PROPORTION              --EAST质押比例
          ,LAST_TIME_CHANGE_DATE          --EAST最近一次变动日期
          ,EAST_REMARK                    --EAST备注
          ,FOREIGN_STOCKHOLDER            --G08外资股东
          ,NATIONALITY                    --G08国别(地区)
          --,PARENT_COMPANY_PLACE         --G08母公司所在国家(地区)
          ,START_DT                       --开始时间
          ,END_DT                         --结束时间
          ,ID_MARK                        --增删标志
          ,ETL_TIMESTAMP                  --ETL处理时间戳
    FROM IOL.V_NOAS_OA_STOCKHOLDER_INFO  --视图-客户股东信息
   WHERE ID_MARK <> 'D';


   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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

  END ETL_O_IOL_NOAS_OA_STOCKHOLDER_INFO;
/

