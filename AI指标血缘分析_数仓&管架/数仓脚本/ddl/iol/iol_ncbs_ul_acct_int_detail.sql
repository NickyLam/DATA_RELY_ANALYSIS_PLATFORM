/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_ul_acct_int_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_ul_acct_int_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_ul_acct_int_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_ul_acct_int_detail(
    cmisloan_no varchar2(60) -- 客户借据编号|客户借据编号
    ,int_class varchar2(5) -- 利息分类|利息分类|int-正常利息,odi-复利,odp-罚息,ododi-复利的复利,ododp-罚息的复利,pdue-超期利息,godp-宽限期利息,wyint-违约利息
    ,batch_no varchar2(50) -- 批次号|批次号
    ,client_no varchar2(16) -- 客户编号|客户编号
    ,int_basis varchar2(5) -- 基准利率类型|基准利率类型
    ,int_basis_rate number(15,8) -- 基准利率|基准利率
    ,spread_rate number(15,8) -- 浮动点数|浮动点数
    ,next_cycle_date date -- 下一结息日|下一结息日
    ,cycle_freq varchar2(5) -- 结息频率|结息频率
    ,int_day varchar2(2) -- 存贷结息日期|存贷结息日期
    ,last_cycle_date date -- 上一结息日|上一结息日
    ,int_type varchar2(5) -- 利率类型|利率类型
    ,real_rate number(15,8) -- 执行利率|执行利率
    ,int_accrued_ctd number(17,2) -- 计提日计提利息|计提日计提利息
    ,int_accrued number(17,2) -- 累计计提|累计计提
    ,int_posted_ctd number(17,2) -- 结息日利息金额|结息日利息金额
    ,int_posted number(17,2) -- 结息金额|结息金额
    ,last_accrual_date date -- 上一利息计提日|上一利息计提日
    ,int_appl_type varchar2(1) -- 利率启用方式|利率启用方式|a-随基准利率变更,n-不变更,r-按周期变更,s-按计息变更,f-浮动不随基准利率变更
    ,rate_effect_type varchar2(1) -- 利率生效方式|利率生效方式|a-按产品,n-按分户,h-就高（贷款使用时）,l-就低（贷款使用时）,n-不比较（贷款使用时）
    ,calc_begin_date date -- 利息计算起始日|利息计算起始日
    ,calc_end_date date -- 利息计算截止日|利息计算截止日
    ,last_change_date date -- 最后修改日期|最后修改日期
    ,year_basis varchar2(3) -- 年基准天数|年基准天数|360-按360天计算日利率,365-按365天计算日利率,366-按366天计算日利率
    ,month_basis varchar2(3) -- 月基准|月基准|act-按实际天数,d30-按30天
    ,int_ind_flag varchar2(1) -- 计息标识|是否计息|y-是、正利率计息,n-否,f-是、负利率计息
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
grant select on ${iol_schema}.ncbs_ul_acct_int_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_ul_acct_int_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_ul_acct_int_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_ul_acct_int_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_ul_acct_int_detail is '联合贷利率信息表|联合贷利率信息表';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.cmisloan_no is '客户借据编号|客户借据编号';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.int_class is '利息分类|利息分类|int-正常利息,odi-复利,odp-罚息,ododi-复利的复利,ododp-罚息的复利,pdue-超期利息,godp-宽限期利息,wyint-违约利息';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.batch_no is '批次号|批次号';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.client_no is '客户编号|客户编号';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.int_basis is '基准利率类型|基准利率类型';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.int_basis_rate is '基准利率|基准利率';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.spread_rate is '浮动点数|浮动点数';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.next_cycle_date is '下一结息日|下一结息日';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.cycle_freq is '结息频率|结息频率';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.int_day is '存贷结息日期|存贷结息日期';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.last_cycle_date is '上一结息日|上一结息日';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.int_type is '利率类型|利率类型';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.real_rate is '执行利率|执行利率';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.int_accrued_ctd is '计提日计提利息|计提日计提利息';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.int_accrued is '累计计提|累计计提';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.int_posted_ctd is '结息日利息金额|结息日利息金额';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.int_posted is '结息金额|结息金额';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.last_accrual_date is '上一利息计提日|上一利息计提日';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.int_appl_type is '利率启用方式|利率启用方式|a-随基准利率变更,n-不变更,r-按周期变更,s-按计息变更,f-浮动不随基准利率变更';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.rate_effect_type is '利率生效方式|利率生效方式|a-按产品,n-按分户,h-就高（贷款使用时）,l-就低（贷款使用时）,n-不比较（贷款使用时）';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.calc_begin_date is '利息计算起始日|利息计算起始日';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.calc_end_date is '利息计算截止日|利息计算截止日';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.last_change_date is '最后修改日期|最后修改日期';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.year_basis is '年基准天数|年基准天数|360-按360天计算日利率,365-按365天计算日利率,366-按366天计算日利率';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.month_basis is '月基准|月基准|act-按实际天数,d30-按30天';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.int_ind_flag is '计息标识|是否计息|y-是、正利率计息,n-否,f-是、负利率计息';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_ul_acct_int_detail.etl_timestamp is 'ETL处理时间戳';
