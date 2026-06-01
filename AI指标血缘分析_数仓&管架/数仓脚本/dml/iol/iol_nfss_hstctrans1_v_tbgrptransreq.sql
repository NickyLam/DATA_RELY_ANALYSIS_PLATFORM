/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_hstctrans1_v_tbgrptransreq
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq_ex purge;
alter table ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq;

-- 2.3 insert data to ex table
create table ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq_ex nologging
compress
as
select * from ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq where 0=1;

insert /*+ append */ into ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq_ex(
    serial_no -- 流水序号:流水号
    ,ex_serial -- 原始请求外部流水号
    ,contract_no -- 合同编号:合约编号
    ,trans_date -- 交易日期
    ,trans_time -- 交易时间
    ,occur_init_date -- 发生交易时的系统日期
    ,in_client_no -- 内部客户编号
    ,virtual_bank_acc -- 虚拟银行账号
    ,trans_code -- 交易代码
    ,control_flag -- 控制标识
    ,branch_no -- 分支机构编号
    ,open_branch -- 所属机构
    ,client_type -- 客户类型:0机构,1个人,2产品
    ,id_type -- 证件类型
    ,id_code -- 证件号码
    ,bank_no -- 银行代码:租户编号(多租户模式用)
    ,client_no -- 银行客户号
    ,bank_acc -- 资金账号
    ,cash_flag -- 钞汇标志:[k_chbz] 0-现钞 1-现汇 2-钞汇均可
    ,trans_account_type -- 交易介质类型:[k_khbslx] 0-入账账号 1-客户号 2-证件
    ,trans_account -- 交易账号:交易介质
    ,channel -- 渠道:暂未启用
    ,term_no -- 终端编号
    ,oper_no -- 操作柜员
    ,auth_oper -- 授权柜员
    ,group_code -- 分组代码
    ,asso_date -- 关联日期
    ,asso_serial -- 关联流水号
    ,asso_serial2 -- 关联流水号2
    ,asso_serial3 -- 关联流水号3
    ,amt -- 金额
    ,ori_channel -- 原流水交易渠道:[k_jyqd] 0	-	柜台交易 1	-	网上银行 2	-	自助查询终端 3	-	电话银行 4	-	atm 5	-	ta发起 6	-	低柜 7	-	手机银行 8	-	质押系统 9	-	批量发起 a	-	ipad b	-	微信 c	-	e贸平台 d	-	个人网银 e	-	企业网银 f	-	银企直连 g	-	web管理台 h	-	现金管理系统 p	-	pos渠道 q	-	直销银行 s	-	工资宝 t	-	金融商城 u	-	移动营销 v	-	网上营业厅 w	-	塑米理财 y	-	流程银行 a	-	贴膜卡 b	-	其他第三方渠道 c	-	京东引流 s	-	司法扣划
    ,ori_branch_no -- 原流水交易机构
    ,larg_red_flag -- 巨额赎回处理标志:0-正常赎回 1-发生巨额赎回
    ,to_lcpt_serial -- 发送理财平台流水号
    ,lcpt_check_date -- 理财平台对帐日期
    ,lcpt_trans_code -- 理财平台交易码
    ,lcpt_date -- 理财平台日期
    ,lcpt_serial -- 理财平台流水号
    ,to_host_serial -- 发送主机流水号
    ,host_check_date -- 主机对账日期
    ,ori_host_chk_date -- 原交易主机对账日期
    ,host_trans_code -- 主机交易码
    ,host_date -- 核心日期:主机日期
    ,host_serial -- 主机流水号
    ,liqu_status -- 账务状态:[k_zwzt] 0	-	账务无关 1	-	待冻结 2	-	待扣款 3	-	已冻结 4	-	已扣款 5	-	待解冻扣款 6	-	已上账 7	-	待上账 8	-	已解冻 9	-	上账并冻结
    ,client_manager -- 客户经理
    ,targ_bank_acc -- 目标银行账号
    ,err_code -- 错误代码
    ,err_msg -- 错误信息
    ,status -- 状态
    ,summary -- 摘要
    ,debit_account -- 认申购账号
    ,crebit_account -- 赎回账号
    ,phy_date -- 物理日期
    ,model -- 模式
    ,reserve1 -- 保留字段1
    ,reserve2 -- 保留字段2
    ,reserve3 -- 保留字段3
    ,reserve4 -- 保留字段4
    ,reserve5 -- 保留字段5
    ,amt1 -- 备用金额1
    ,amt2 -- 备用金额2
    ,amt3 -- 备用金额3
    ,amt4 -- 备用金额4
    ,amt5 -- 备用金额5
    ,amt6 -- 备用金额6
    ,double1 -- 扩展浮点数1
    ,double2 -- 备用double2
    ,double3 -- 备用double3
    ,double4 -- 备用double4
    ,double5 -- 备用double5
    ,reserve6 -- 保留字段6
    ,reserve7 -- 保留字段7
    ,reserve8 -- 保留字段8
    ,redem_account -- 组合赎回归集户
    ,child_prd_codes -- 产品代码序列
    ,child_prd_rates -- 调仓前子产品占比
    ,child_new_prd_rates -- 调仓后子产品占比
    ,modify_timestamp -- 修改时间戳
    ,client_name -- 客户姓名:客户名称
    ,mobile -- 手机号码
    ,cfm_amt -- 确认金额
    ,cfm_date -- 确认日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    serial_no -- 流水序号:流水号
    ,ex_serial -- 原始请求外部流水号
    ,contract_no -- 合同编号:合约编号
    ,trans_date -- 交易日期
    ,trans_time -- 交易时间
    ,occur_init_date -- 发生交易时的系统日期
    ,in_client_no -- 内部客户编号
    ,virtual_bank_acc -- 虚拟银行账号
    ,trans_code -- 交易代码
    ,control_flag -- 控制标识
    ,branch_no -- 分支机构编号
    ,open_branch -- 所属机构
    ,client_type -- 客户类型:0机构,1个人,2产品
    ,id_type -- 证件类型
    ,id_code -- 证件号码
    ,bank_no -- 银行代码:租户编号(多租户模式用)
    ,client_no -- 银行客户号
    ,bank_acc -- 资金账号
    ,cash_flag -- 钞汇标志:[k_chbz] 0-现钞 1-现汇 2-钞汇均可
    ,trans_account_type -- 交易介质类型:[k_khbslx] 0-入账账号 1-客户号 2-证件
    ,trans_account -- 交易账号:交易介质
    ,channel -- 渠道:暂未启用
    ,term_no -- 终端编号
    ,oper_no -- 操作柜员
    ,auth_oper -- 授权柜员
    ,group_code -- 分组代码
    ,asso_date -- 关联日期
    ,asso_serial -- 关联流水号
    ,asso_serial2 -- 关联流水号2
    ,asso_serial3 -- 关联流水号3
    ,amt -- 金额
    ,ori_channel -- 原流水交易渠道:[k_jyqd] 0	-	柜台交易 1	-	网上银行 2	-	自助查询终端 3	-	电话银行 4	-	atm 5	-	ta发起 6	-	低柜 7	-	手机银行 8	-	质押系统 9	-	批量发起 a	-	ipad b	-	微信 c	-	e贸平台 d	-	个人网银 e	-	企业网银 f	-	银企直连 g	-	web管理台 h	-	现金管理系统 p	-	pos渠道 q	-	直销银行 s	-	工资宝 t	-	金融商城 u	-	移动营销 v	-	网上营业厅 w	-	塑米理财 y	-	流程银行 a	-	贴膜卡 b	-	其他第三方渠道 c	-	京东引流 s	-	司法扣划
    ,ori_branch_no -- 原流水交易机构
    ,larg_red_flag -- 巨额赎回处理标志:0-正常赎回 1-发生巨额赎回
    ,to_lcpt_serial -- 发送理财平台流水号
    ,lcpt_check_date -- 理财平台对帐日期
    ,lcpt_trans_code -- 理财平台交易码
    ,lcpt_date -- 理财平台日期
    ,lcpt_serial -- 理财平台流水号
    ,to_host_serial -- 发送主机流水号
    ,host_check_date -- 主机对账日期
    ,ori_host_chk_date -- 原交易主机对账日期
    ,host_trans_code -- 主机交易码
    ,host_date -- 核心日期:主机日期
    ,host_serial -- 主机流水号
    ,liqu_status -- 账务状态:[k_zwzt] 0	-	账务无关 1	-	待冻结 2	-	待扣款 3	-	已冻结 4	-	已扣款 5	-	待解冻扣款 6	-	已上账 7	-	待上账 8	-	已解冻 9	-	上账并冻结
    ,client_manager -- 客户经理
    ,targ_bank_acc -- 目标银行账号
    ,err_code -- 错误代码
    ,err_msg -- 错误信息
    ,status -- 状态
    ,summary -- 摘要
    ,debit_account -- 认申购账号
    ,crebit_account -- 赎回账号
    ,phy_date -- 物理日期
    ,model -- 模式
    ,reserve1 -- 保留字段1
    ,reserve2 -- 保留字段2
    ,reserve3 -- 保留字段3
    ,reserve4 -- 保留字段4
    ,reserve5 -- 保留字段5
    ,amt1 -- 备用金额1
    ,amt2 -- 备用金额2
    ,amt3 -- 备用金额3
    ,amt4 -- 备用金额4
    ,amt5 -- 备用金额5
    ,amt6 -- 备用金额6
    ,double1 -- 扩展浮点数1
    ,double2 -- 备用double2
    ,double3 -- 备用double3
    ,double4 -- 备用double4
    ,double5 -- 备用double5
    ,reserve6 -- 保留字段6
    ,reserve7 -- 保留字段7
    ,reserve8 -- 保留字段8
    ,redem_account -- 组合赎回归集户
    ,child_prd_codes -- 产品代码序列
    ,child_prd_rates -- 调仓前子产品占比
    ,child_new_prd_rates -- 调仓后子产品占比
    ,modify_timestamp -- 修改时间戳
    ,client_name -- 客户姓名:客户名称
    ,mobile -- 手机号码
    ,cfm_amt -- 确认金额
    ,cfm_date -- 确认日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nfss_hstctrans1_v_tbgrptransreq
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq exchange partition p_${batch_date} with table ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_hstctrans1_v_tbgrptransreq',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);