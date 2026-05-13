CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_BDMS_CPES_RECOVERY_HAND_AGREEPAY(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_BDMS_CPES_RECOVERY_HAND_AGREEPAY
  *  功能描述：贴现前手动追索同意清偿表
  *  创建日期：20251113
  *  开发人员：于敬艺
  *  来源表： IOL.V_BDMS_CPES_RECOVERY_HAND_AGREEPAY
  *  目标表： O_IOL_BDMS_CPES_RECOVERY_HAND_AGREEPAY
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251113  YJY     首次创建
  *************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_BDMS_CPES_RECOVERY_HAND_AGREEPAY'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_BDMS_CPES_RECOVERY_HAND_AGREEPAY';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-贴现前手动追索同意清偿表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_BDMS_CPES_RECOVERY_HAND_AGREEPAY NOLOGGING
    (   ID                          --主键
       ,BUSS_FLAG                   --交易方向： 01 申请 02 签收
       ,PRODUCT_NO                  --产品号
       ,DRAFT_ID                    --同意清偿票据ID
       ,HAND_APPLY_ID               --贴现前手动追索申请表CPES_RECOVERY_HAND_APPLY的ID
       ,PUB_APPLY_ID                --报文公共签收表HTES_PREDISCOUNT_PUB_APPLY的ID
       ,RECOVERY_TYPE               --追索类型： BC14 拒付追索 BC15 非拒付追索
       ,DRAFT_NUMBER                --票据（包）号
       ,CD_RANGE                    --同意清偿区间
       ,DRAFT_AMOUNT                --同意清偿金额
       ,RECOVERY_BUSS_TYPE          --追索人业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台
       ,RECOVERY_NAME               --追索人名称
       ,RECOVERY_CERT_NO            --追索人社会信息用代码
       ,RECOVERY_DIST_TP            --追索人识别类型： DT01 票据账户 DT02 银行账户
       ,RECOVERY_ACCOUNT            --追索人账号
       ,RECOVERY_BRH_NO             --追索人(开户)机构代码
       ,RECOVERY_BANK_NO            --追索人(开户)行号
       ,RECOVERY_NOTICE_DATE        --追索通知日期
       ,RECOVERY_NOTICE_MISC        --追索通知备注
       ,RECOVERY_BACKMISC           --追索人撤销说明
       ,RECOVERY_SIGN_DATE          --追索人应答日期
       ,RECOVERY_SIGN_MK            --追索人应答标识： SU00 同意 SU01 拒绝
       ,RECOVERY_SIGN_MISC          --追索人应答备注
       ,BERECOVERED_BUSS_TYPE       --被追索人业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台
       ,BERECOVERED_NAME            --被追索人名称
       ,BERECOVERED_CERT_NO         --被追索人社会信息用代码
       ,BERECOVERED_DIST_TP         --被追索人识别类型： DT01 票据账户 DT02 银行账户
       ,BERECOVERED_ACCOUNT         --被追索人账号
       ,BERECOVERED_BRH_NO          --被追索人(开户)机构代码
       ,BERECOVERED_AGREE_DATE      --被追索人同意清偿的申请日期
       ,BERECOVERED_AGREE_MISC      --被追索人同意清偿备注
       ,BERECOVERED_AGREE_NUMBER    --被追索人同意清偿子票据张数
       ,BERECOVERED_SETTLE_ACCOUNT  --被追索人结算账号
       ,BERECOVERED_SETTLE_BANK_NO  --被追索人结算行号
       ,BERECOVERED_BACKMISC        --被追索人撤销说明
       ,SETTLE_TYPE                 --结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
       ,CLEAR_TYPE                  --清算类型： CT01 全额清算 CT02 净额清算
       ,SETTLE_DATE                 --被追索人同意清偿日期（结算日期）
       ,DEAL_STATUS                 --处理状态： 00 已发送申请报文 01 已发送申请报文，收到票交所确认成功 02 已发送申请报文，收到票交所确认失败 03 已发送申请报文，收到票交所确认，对方已同意签收 04 已发送申请报文，收到票交所确认，对方已拒绝签收 05 已发送申请报文，收到票交所确认，已发撤回报文 06 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认成功 07 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认失败 11 已发送同意签收报文 12 已发送同意签收报文，收到票交所确认成功 13 已发送同意签收报文，收到票交所确认失败 14 已发送拒绝签收报文 15 已发送拒绝签收报文，收到票交所确认成功 16 已发送拒绝签收报文，收到票交所确认失败 20 对方已撤回 21 收到人行线上清退
       ,SETTLE_STATUS               --清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
       ,ACCOUNT_STATUS              --记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
       ,ERR_CODE                    --错误码
       ,ERR_MSG                     --错误信息
       ,BRANCH_NO                   --行内机构号
       ,BELONG_BRH_NO               --所属票交所机构号/非法人产品
       ,TOP_BRANCH_NO               --行内总行机构号
       ,CREATE_OPR                  --创建人
       ,LAST_UPD_OPR                --最后操作人
       ,LAST_UPD_TIME               --最后修改时间
       ,RECOVERY_MEM_NO             --追索人渠道代码
       ,BERECOVERED_MEM_NO          --被追索人渠道代码
       ,RECOVERY_RANGE              --追索通知区间
       ,RECOVERY_AMOUNT             --追索通知金额
       ,RECOVERY_ACCOUNT_NAME       --追索人账户名称
       ,RECOVERY_SETTLE_ACCOUNT_NAME  --追索人结算账户名称
       ,RECOVERY_SETTLE_ACCOUNT     --追索人结算账号
       ,RECOVERY_SETTLE_BRH_NO      --追索人结算账户机构代码
       ,RECOVERY_BT_NO              --追索人业务批次号
       ,BERECOVERED_ACCOUNT_NAME    --被追索人账户名称
       ,BERECOVERED_SETTLE_ACCOUNT_NAM  --被追索人结算账户名称
       ,BERECOVERED_SETTLE_BRH_NO   --被追索人结算账户机构代码
       ,BERECOVERED_BT_NO           --被追索人业务批次号
       ,SETTLE_AMOUNT               --结算金额
       ,ETL_DT                      --ETL处理日期
       ,ETL_TIMESTAMP               --ETL处理时间戳
     )
  SELECT /*+PARALLEL*/
        ID                          --主键
       ,BUSS_FLAG                   --交易方向： 01 申请 02 签收
       ,PRODUCT_NO                  --产品号
       ,DRAFT_ID                    --同意清偿票据ID
       ,HAND_APPLY_ID               --贴现前手动追索申请表CPES_RECOVERY_HAND_APPLY的ID
       ,PUB_APPLY_ID                --报文公共签收表HTES_PREDISCOUNT_PUB_APPLY的ID
       ,RECOVERY_TYPE               --追索类型： BC14 拒付追索 BC15 非拒付追索
       ,DRAFT_NUMBER                --票据（包）号
       ,CD_RANGE                    --同意清偿区间
       ,DRAFT_AMOUNT                --同意清偿金额
       ,RECOVERY_BUSS_TYPE          --追索人业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台
       ,RECOVERY_NAME               --追索人名称
       ,RECOVERY_CERT_NO            --追索人社会信息用代码
       ,RECOVERY_DIST_TP            --追索人识别类型： DT01 票据账户 DT02 银行账户
       ,RECOVERY_ACCOUNT            --追索人账号
       ,RECOVERY_BRH_NO             --追索人(开户)机构代码
       ,RECOVERY_BANK_NO            --追索人(开户)行号
       ,RECOVERY_NOTICE_DATE        --追索通知日期
       ,RECOVERY_NOTICE_MISC        --追索通知备注
       ,RECOVERY_BACKMISC           --追索人撤销说明
       ,RECOVERY_SIGN_DATE          --追索人应答日期
       ,RECOVERY_SIGN_MK            --追索人应答标识： SU00 同意 SU01 拒绝
       ,RECOVERY_SIGN_MISC          --追索人应答备注
       ,BERECOVERED_BUSS_TYPE       --被追索人业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台
       ,BERECOVERED_NAME            --被追索人名称
       ,BERECOVERED_CERT_NO         --被追索人社会信息用代码
       ,BERECOVERED_DIST_TP         --被追索人识别类型： DT01 票据账户 DT02 银行账户
       ,BERECOVERED_ACCOUNT         --被追索人账号
       ,BERECOVERED_BRH_NO          --被追索人(开户)机构代码
       ,BERECOVERED_AGREE_DATE      --被追索人同意清偿的申请日期
       ,BERECOVERED_AGREE_MISC      --被追索人同意清偿备注
       ,BERECOVERED_AGREE_NUMBER    --被追索人同意清偿子票据张数
       ,BERECOVERED_SETTLE_ACCOUNT  --被追索人结算账号
       ,BERECOVERED_SETTLE_BANK_NO  --被追索人结算行号
       ,BERECOVERED_BACKMISC        --被追索人撤销说明
       ,SETTLE_TYPE                 --结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
       ,CLEAR_TYPE                  --清算类型： CT01 全额清算 CT02 净额清算
       ,SETTLE_DATE                 --被追索人同意清偿日期（结算日期）
       ,DEAL_STATUS                 --处理状态： 00 已发送申请报文 01 已发送申请报文，收到票交所确认成功 02 已发送申请报文，收到票交所确认失败 03 已发送申请报文，收到票交所确认，对方已同意签收 04 已发送申请报文，收到票交所确认，对方已拒绝签收 05 已发送申请报文，收到票交所确认，已发撤回报文 06 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认成功 07 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认失败 11 已发送同意签收报文 12 已发送同意签收报文，收到票交所确认成功 13 已发送同意签收报文，收到票交所确认失败 14 已发送拒绝签收报文 15 已发送拒绝签收报文，收到票交所确认成功 16 已发送拒绝签收报文，收到票交所确认失败 20 对方已撤回 21 收到人行线上清退
       ,SETTLE_STATUS               --清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
       ,ACCOUNT_STATUS              --记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
       ,ERR_CODE                    --错误码
       ,ERR_MSG                     --错误信息
       ,BRANCH_NO                   --行内机构号
       ,BELONG_BRH_NO               --所属票交所机构号/非法人产品
       ,TOP_BRANCH_NO               --行内总行机构号
       ,CREATE_OPR                  --创建人
       ,LAST_UPD_OPR                --最后操作人
       ,LAST_UPD_TIME               --最后修改时间
       ,RECOVERY_MEM_NO             --追索人渠道代码
       ,BERECOVERED_MEM_NO          --被追索人渠道代码
       ,RECOVERY_RANGE              --追索通知区间
       ,RECOVERY_AMOUNT             --追索通知金额
       ,RECOVERY_ACCOUNT_NAME       --追索人账户名称
       ,RECOVERY_SETTLE_ACCOUNT_NAME  --追索人结算账户名称
       ,RECOVERY_SETTLE_ACCOUNT     --追索人结算账号
       ,RECOVERY_SETTLE_BRH_NO      --追索人结算账户机构代码
       ,RECOVERY_BT_NO              --追索人业务批次号
       ,BERECOVERED_ACCOUNT_NAME    --被追索人账户名称
       ,BERECOVERED_SETTLE_ACCOUNT_NAM  --被追索人结算账户名称
       ,BERECOVERED_SETTLE_BRH_NO   --被追索人结算账户机构代码
       ,BERECOVERED_BT_NO           --被追索人业务批次号
       ,SETTLE_AMOUNT               --结算金额
       ,ETL_DT                      --ETL处理日期
       ,ETL_TIMESTAMP               --ETL处理时间戳
    FROM IOL.V_BDMS_CPES_RECOVERY_HAND_AGREEPAY   --贴现前手动追索同意清偿表_视图
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       ;

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

  END ETL_O_IOL_BDMS_CPES_RECOVERY_HAND_AGREEPAY;
/

