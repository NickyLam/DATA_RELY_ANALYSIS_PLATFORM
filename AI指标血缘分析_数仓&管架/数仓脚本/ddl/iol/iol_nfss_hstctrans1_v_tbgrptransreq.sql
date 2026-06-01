/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_hstctrans1_v_tbgrptransreq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq(
    serial_no varchar2(48) -- 流水序号:流水号
    ,ex_serial varchar2(48) -- 原始请求外部流水号
    ,contract_no varchar2(48) -- 合同编号:合约编号
    ,trans_date number(38) -- 交易日期
    ,trans_time number(38) -- 交易时间
    ,occur_init_date number(38) -- 发生交易时的系统日期
    ,in_client_no varchar2(30) -- 内部客户编号
    ,virtual_bank_acc varchar2(48) -- 虚拟银行账号
    ,trans_code varchar2(48) -- 交易代码
    ,control_flag varchar2(768) -- 控制标识
    ,branch_no varchar2(24) -- 分支机构编号
    ,open_branch varchar2(120) -- 所属机构
    ,client_type varchar2(2) -- 客户类型:0机构,1个人,2产品
    ,id_type varchar2(5) -- 证件类型
    ,id_code varchar2(75) -- 证件号码
    ,bank_no varchar2(48) -- 银行代码:租户编号(多租户模式用)
    ,client_no varchar2(36) -- 银行客户号
    ,bank_acc varchar2(96) -- 资金账号
    ,cash_flag varchar2(2) -- 钞汇标志:[k_chbz] 0-现钞 1-现汇 2-钞汇均可
    ,trans_account_type varchar2(2) -- 交易介质类型:[k_khbslx] 0-入账账号 1-客户号 2-证件
    ,trans_account varchar2(48) -- 交易账号:交易介质
    ,channel varchar2(2) -- 渠道:暂未启用
    ,term_no varchar2(24) -- 终端编号
    ,oper_no varchar2(48) -- 操作柜员
    ,auth_oper varchar2(48) -- 授权柜员
    ,group_code varchar2(48) -- 分组代码
    ,asso_date number(38) -- 关联日期
    ,asso_serial varchar2(48) -- 关联流水号
    ,asso_serial2 varchar2(48) -- 关联流水号2
    ,asso_serial3 varchar2(48) -- 关联流水号3
    ,amt number(18,2) -- 金额
    ,ori_channel varchar2(2) -- 原流水交易渠道:[k_jyqd] 0	-	柜台交易 1	-	网上银行 2	-	自助查询终端 3	-	电话银行 4	-	atm 5	-	ta发起 6	-	低柜 7	-	手机银行 8	-	质押系统 9	-	批量发起 a	-	ipad b	-	微信 c	-	e贸平台 d	-	个人网银 e	-	企业网银 f	-	银企直连 g	-	web管理台 h	-	现金管理系统 p	-	pos渠道 q	-	直销银行 s	-	工资宝 t	-	金融商城 u	-	移动营销 v	-	网上营业厅 w	-	塑米理财 y	-	流程银行 a	-	贴膜卡 b	-	其他第三方渠道 c	-	京东引流 s	-	司法扣划
    ,ori_branch_no varchar2(24) -- 原流水交易机构
    ,larg_red_flag varchar2(2) -- 巨额赎回处理标志:0-正常赎回 1-发生巨额赎回
    ,to_lcpt_serial varchar2(48) -- 发送理财平台流水号
    ,lcpt_check_date number(38) -- 理财平台对帐日期
    ,lcpt_trans_code varchar2(9) -- 理财平台交易码
    ,lcpt_date number(38) -- 理财平台日期
    ,lcpt_serial varchar2(48) -- 理财平台流水号
    ,to_host_serial varchar2(48) -- 发送主机流水号
    ,host_check_date number(38) -- 主机对账日期
    ,ori_host_chk_date number(38) -- 原交易主机对账日期
    ,host_trans_code varchar2(9) -- 主机交易码
    ,host_date number(38) -- 核心日期:主机日期
    ,host_serial varchar2(48) -- 主机流水号
    ,liqu_status varchar2(2) -- 账务状态:[k_zwzt] 0	-	账务无关 1	-	待冻结 2	-	待扣款 3	-	已冻结 4	-	已扣款 5	-	待解冻扣款 6	-	已上账 7	-	待上账 8	-	已解冻 9	-	上账并冻结
    ,client_manager varchar2(48) -- 客户经理
    ,targ_bank_acc varchar2(48) -- 目标银行账号
    ,err_code varchar2(18) -- 错误代码
    ,err_msg varchar2(768) -- 错误信息
    ,status varchar2(2) -- 状态
    ,summary varchar2(375) -- 摘要
    ,debit_account varchar2(48) -- 认申购账号
    ,crebit_account varchar2(48) -- 赎回账号
    ,phy_date number(38) -- 物理日期
    ,model varchar2(2) -- 模式
    ,reserve1 varchar2(375) -- 保留字段1
    ,reserve2 varchar2(375) -- 保留字段2
    ,reserve3 varchar2(375) -- 保留字段3
    ,reserve4 varchar2(375) -- 保留字段4
    ,reserve5 varchar2(375) -- 保留字段5
    ,amt1 number(18,2) -- 备用金额1
    ,amt2 number(18,2) -- 备用金额2
    ,amt3 number(18,2) -- 备用金额3
    ,amt4 number(18,2) -- 备用金额4
    ,amt5 number(18,2) -- 备用金额5
    ,amt6 number(18,2) -- 备用金额6
    ,double1 number(22,8) -- 扩展浮点数1
    ,double2 number(22,8) -- 备用double2
    ,double3 number(22,8) -- 备用double3
    ,double4 number(22,8) -- 备用double4
    ,double5 number(22,8) -- 备用double5
    ,reserve6 varchar2(768) -- 保留字段6
    ,reserve7 varchar2(375) -- 保留字段7
    ,reserve8 varchar2(375) -- 保留字段8
    ,redem_account varchar2(48) -- 组合赎回归集户
    ,child_prd_codes varchar2(4000) -- 产品代码序列
    ,child_prd_rates varchar2(600) -- 调仓前子产品占比
    ,child_new_prd_rates varchar2(600) -- 调仓后子产品占比
    ,modify_timestamp number(14,0) -- 修改时间戳
    ,client_name varchar2(375) -- 客户姓名:客户名称
    ,mobile varchar2(60) -- 手机号码
    ,cfm_amt number(18,2) -- 确认金额
    ,cfm_date number(38) -- 确认日期
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq to ${iml_schema};
grant select on ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq to ${icl_schema};
grant select on ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq to ${idl_schema};
grant select on ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq is '交易主流水表';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.serial_no is '流水序号:流水号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.ex_serial is '原始请求外部流水号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.contract_no is '合同编号:合约编号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.trans_date is '交易日期';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.trans_time is '交易时间';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.occur_init_date is '发生交易时的系统日期';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.in_client_no is '内部客户编号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.virtual_bank_acc is '虚拟银行账号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.trans_code is '交易代码';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.control_flag is '控制标识';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.branch_no is '分支机构编号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.open_branch is '所属机构';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.client_type is '客户类型:0机构,1个人,2产品';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.id_type is '证件类型';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.id_code is '证件号码';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.bank_no is '银行代码:租户编号(多租户模式用)';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.client_no is '银行客户号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.bank_acc is '资金账号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.cash_flag is '钞汇标志:[k_chbz] 0-现钞 1-现汇 2-钞汇均可';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.trans_account_type is '交易介质类型:[k_khbslx] 0-入账账号 1-客户号 2-证件';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.trans_account is '交易账号:交易介质';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.channel is '渠道:暂未启用';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.term_no is '终端编号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.oper_no is '操作柜员';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.auth_oper is '授权柜员';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.group_code is '分组代码';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.asso_date is '关联日期';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.asso_serial is '关联流水号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.asso_serial2 is '关联流水号2';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.asso_serial3 is '关联流水号3';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.amt is '金额';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.ori_channel is '原流水交易渠道:[k_jyqd] 0	-	柜台交易 1	-	网上银行 2	-	自助查询终端 3	-	电话银行 4	-	atm 5	-	ta发起 6	-	低柜 7	-	手机银行 8	-	质押系统 9	-	批量发起 a	-	ipad b	-	微信 c	-	e贸平台 d	-	个人网银 e	-	企业网银 f	-	银企直连 g	-	web管理台 h	-	现金管理系统 p	-	pos渠道 q	-	直销银行 s	-	工资宝 t	-	金融商城 u	-	移动营销 v	-	网上营业厅 w	-	塑米理财 y	-	流程银行 a	-	贴膜卡 b	-	其他第三方渠道 c	-	京东引流 s	-	司法扣划';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.ori_branch_no is '原流水交易机构';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.larg_red_flag is '巨额赎回处理标志:0-正常赎回 1-发生巨额赎回';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.to_lcpt_serial is '发送理财平台流水号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.lcpt_check_date is '理财平台对帐日期';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.lcpt_trans_code is '理财平台交易码';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.lcpt_date is '理财平台日期';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.lcpt_serial is '理财平台流水号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.to_host_serial is '发送主机流水号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.host_check_date is '主机对账日期';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.ori_host_chk_date is '原交易主机对账日期';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.host_trans_code is '主机交易码';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.host_date is '核心日期:主机日期';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.host_serial is '主机流水号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.liqu_status is '账务状态:[k_zwzt] 0	-	账务无关 1	-	待冻结 2	-	待扣款 3	-	已冻结 4	-	已扣款 5	-	待解冻扣款 6	-	已上账 7	-	待上账 8	-	已解冻 9	-	上账并冻结';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.client_manager is '客户经理';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.targ_bank_acc is '目标银行账号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.err_code is '错误代码';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.err_msg is '错误信息';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.status is '状态';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.summary is '摘要';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.debit_account is '认申购账号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.crebit_account is '赎回账号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.phy_date is '物理日期';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.model is '模式';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.reserve1 is '保留字段1';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.reserve2 is '保留字段2';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.reserve3 is '保留字段3';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.reserve4 is '保留字段4';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.reserve5 is '保留字段5';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.amt1 is '备用金额1';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.amt2 is '备用金额2';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.amt3 is '备用金额3';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.amt4 is '备用金额4';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.amt5 is '备用金额5';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.amt6 is '备用金额6';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.double1 is '扩展浮点数1';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.double2 is '备用double2';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.double3 is '备用double3';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.double4 is '备用double4';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.double5 is '备用double5';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.reserve6 is '保留字段6';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.reserve7 is '保留字段7';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.reserve8 is '保留字段8';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.redem_account is '组合赎回归集户';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.child_prd_codes is '产品代码序列';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.child_prd_rates is '调仓前子产品占比';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.child_new_prd_rates is '调仓后子产品占比';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.modify_timestamp is '修改时间戳';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.client_name is '客户姓名:客户名称';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.mobile is '手机号码';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.cfm_amt is '确认金额';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.cfm_date is '确认日期';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrptransreq.etl_timestamp is 'ETL处理时间戳';
