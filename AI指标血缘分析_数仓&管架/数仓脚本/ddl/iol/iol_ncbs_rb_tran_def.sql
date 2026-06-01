/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_tran_def
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_tran_def
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_tran_def purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_tran_def(
    tran_type varchar2(10) -- 交易类型
    ,availbal_calc_type varchar2(1) -- 可用余额计算类型
    ,bal_type_priority varchar2(5) -- 余额类型次序
    ,balance_flag varchar2(1) -- 余额标志
    ,cash_tran_flag varchar2(1) -- 现金交易
    ,company varchar2(20) -- 法人
    ,correct_flag varchar2(1) -- 更正交易
    ,cr_dr_ind varchar2(1) -- 借贷标志
    ,is_init_param varchar2(1) -- 是否出厂参数
    ,multi_rvs_tran_type_flag varchar2(1) -- 多种冲正方式标志
    ,oth_tran_type varchar2(10) -- 对方交易类型
    ,print_tran_desc varchar2(50) -- 凭证打印交易描述
    ,program_id_group varchar2(200) -- 交易类型与交易界面对应关系
    ,recalc_acct_stop_pay_flag varchar2(1) -- 重新计算余额止付标志
    ,recalc_res_amt_flag varchar2(1) -- 重新计算限制金额标志
    ,res_priority varchar2(2) -- 冻结级别
    ,reversal varchar2(1) -- 是否冲正标志
    ,reversal_tran_type varchar2(10) -- 冲正交易类型
    ,source_type varchar2(6) -- 渠道编号
    ,tran_class varchar2(10) -- 交易分类
    ,tran_type_desc varchar2(200) -- 交易类型描述
    ,libra_op_time number(15) -- libra执行次数
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,upd_tailbox_flag varchar2(1) -- 尾箱更新标志
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_rb_tran_def to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_tran_def to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_tran_def to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_tran_def to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_tran_def is '交易类型定义表';
comment on column ${iol_schema}.ncbs_rb_tran_def.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_tran_def.availbal_calc_type is '可用余额计算类型';
comment on column ${iol_schema}.ncbs_rb_tran_def.bal_type_priority is '余额类型次序';
comment on column ${iol_schema}.ncbs_rb_tran_def.balance_flag is '余额标志';
comment on column ${iol_schema}.ncbs_rb_tran_def.cash_tran_flag is '现金交易';
comment on column ${iol_schema}.ncbs_rb_tran_def.company is '法人';
comment on column ${iol_schema}.ncbs_rb_tran_def.correct_flag is '更正交易';
comment on column ${iol_schema}.ncbs_rb_tran_def.cr_dr_ind is '借贷标志';
comment on column ${iol_schema}.ncbs_rb_tran_def.is_init_param is '是否出厂参数';
comment on column ${iol_schema}.ncbs_rb_tran_def.multi_rvs_tran_type_flag is '多种冲正方式标志';
comment on column ${iol_schema}.ncbs_rb_tran_def.oth_tran_type is '对方交易类型';
comment on column ${iol_schema}.ncbs_rb_tran_def.print_tran_desc is '凭证打印交易描述';
comment on column ${iol_schema}.ncbs_rb_tran_def.program_id_group is '交易类型与交易界面对应关系';
comment on column ${iol_schema}.ncbs_rb_tran_def.recalc_acct_stop_pay_flag is '重新计算余额止付标志';
comment on column ${iol_schema}.ncbs_rb_tran_def.recalc_res_amt_flag is '重新计算限制金额标志';
comment on column ${iol_schema}.ncbs_rb_tran_def.res_priority is '冻结级别';
comment on column ${iol_schema}.ncbs_rb_tran_def.reversal is '是否冲正标志';
comment on column ${iol_schema}.ncbs_rb_tran_def.reversal_tran_type is '冲正交易类型';
comment on column ${iol_schema}.ncbs_rb_tran_def.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_tran_def.tran_class is '交易分类';
comment on column ${iol_schema}.ncbs_rb_tran_def.tran_type_desc is '交易类型描述';
comment on column ${iol_schema}.ncbs_rb_tran_def.libra_op_time is 'libra执行次数';
comment on column ${iol_schema}.ncbs_rb_tran_def.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_tran_def.upd_tailbox_flag is '尾箱更新标志';
comment on column ${iol_schema}.ncbs_rb_tran_def.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_tran_def.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_tran_def.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_tran_def.etl_timestamp is 'ETL处理时间戳';
