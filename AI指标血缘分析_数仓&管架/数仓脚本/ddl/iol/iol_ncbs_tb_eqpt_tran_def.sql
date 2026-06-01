/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_eqpt_tran_def
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_eqpt_tran_def
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_eqpt_tran_def purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_eqpt_tran_def(
    amt_type varchar2(10) -- 金额类型
    ,prod_type varchar2(12) -- 产品编号
    ,tran_type varchar2(10) -- 交易类型
    ,cash_equal varchar2(1) -- 现金碰库标志
    ,company varchar2(20) -- 法人
    ,cv_flag varchar2(1) -- 现金/凭证标志
    ,event_type varchar2(20) -- 事件类型
    ,centralize_flag varchar2(1) -- 是否集中式
    ,move_type varchar2(3) -- 转移类型
    ,pay_rec varchar2(1) -- 收付标志
    ,post_flag varchar2(1) -- 是否生成分录
    ,reversal varchar2(1) -- 是否冲正标志
    ,tailbox_type varchar2(1) -- 尾箱类型
    ,tran_desc varchar2(200) -- 交易描述
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,contra_branch_type varchar2(1) -- 对方机构类型
    ,move_status varchar2(1) -- 转移状态
    ,eqpt_type varchar2(5) -- 自助设备类型
    ,eqpt_tran_status varchar2(2) -- 自助设备交易流程状态
    ,amt_change_type varchar2(5) -- 金额变化类型
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
grant select on ${iol_schema}.ncbs_tb_eqpt_tran_def to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_eqpt_tran_def to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_eqpt_tran_def to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_eqpt_tran_def to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_eqpt_tran_def is '自助设备交易类型定义表';
comment on column ${iol_schema}.ncbs_tb_eqpt_tran_def.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_tb_eqpt_tran_def.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_tb_eqpt_tran_def.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_tb_eqpt_tran_def.cash_equal is '现金碰库标志';
comment on column ${iol_schema}.ncbs_tb_eqpt_tran_def.company is '法人';
comment on column ${iol_schema}.ncbs_tb_eqpt_tran_def.cv_flag is '现金/凭证标志';
comment on column ${iol_schema}.ncbs_tb_eqpt_tran_def.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_tb_eqpt_tran_def.centralize_flag is '是否集中式';
comment on column ${iol_schema}.ncbs_tb_eqpt_tran_def.move_type is '转移类型';
comment on column ${iol_schema}.ncbs_tb_eqpt_tran_def.pay_rec is '收付标志';
comment on column ${iol_schema}.ncbs_tb_eqpt_tran_def.post_flag is '是否生成分录';
comment on column ${iol_schema}.ncbs_tb_eqpt_tran_def.reversal is '是否冲正标志';
comment on column ${iol_schema}.ncbs_tb_eqpt_tran_def.tailbox_type is '尾箱类型';
comment on column ${iol_schema}.ncbs_tb_eqpt_tran_def.tran_desc is '交易描述';
comment on column ${iol_schema}.ncbs_tb_eqpt_tran_def.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_eqpt_tran_def.contra_branch_type is '对方机构类型';
comment on column ${iol_schema}.ncbs_tb_eqpt_tran_def.move_status is '转移状态';
comment on column ${iol_schema}.ncbs_tb_eqpt_tran_def.eqpt_type is '自助设备类型';
comment on column ${iol_schema}.ncbs_tb_eqpt_tran_def.eqpt_tran_status is '自助设备交易流程状态';
comment on column ${iol_schema}.ncbs_tb_eqpt_tran_def.amt_change_type is '金额变化类型';
comment on column ${iol_schema}.ncbs_tb_eqpt_tran_def.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_eqpt_tran_def.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_eqpt_tran_def.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_eqpt_tran_def.etl_timestamp is 'ETL处理时间戳';
