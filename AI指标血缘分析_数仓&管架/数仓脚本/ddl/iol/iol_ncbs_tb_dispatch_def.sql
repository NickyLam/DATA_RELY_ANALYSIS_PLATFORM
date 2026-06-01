/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_dispatch_def
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_dispatch_def
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_dispatch_def purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_dispatch_def(
    tran_type varchar2(10) -- 交易类型
    ,acgl_flag varchar2(1) -- 记账种类
    ,acs_flag varchar2(1) -- 人行联网取现标志
    ,company varchar2(20) -- 法人
    ,contra_event_type varchar2(10) -- 对手事件类型
    ,contra_tran_type varchar2(10) -- 对手交易类型
    ,cv_flag varchar2(1) -- 现金/凭证标志
    ,event_type varchar2(20) -- 事件类型
    ,move_type varchar2(3) -- 转移类型
    ,post_flag varchar2(1) -- 是否生成分录
    ,seq_no varchar2(50) -- 序号
    ,tran_desc varchar2(200) -- 交易描述
    ,use_by_order_flag varchar2(1) -- 是否按顺序使用
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,contra_branch_type varchar2(1) -- 对方机构类型
    ,dispatch_option varchar2(3) -- 调拨业务标记
    ,inout_confirm_flag varchar2(1) -- 出入库确认标志
    ,confirm_event_type varchar2(20) -- 确认事件类型
    ,confirm_tran_type varchar2(10) -- 确认交易类型
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
grant select on ${iol_schema}.ncbs_tb_dispatch_def to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_dispatch_def to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_dispatch_def to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_dispatch_def to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_dispatch_def is '现金凭证调拨参数配置表';
comment on column ${iol_schema}.ncbs_tb_dispatch_def.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_tb_dispatch_def.acgl_flag is '记账种类';
comment on column ${iol_schema}.ncbs_tb_dispatch_def.acs_flag is '人行联网取现标志';
comment on column ${iol_schema}.ncbs_tb_dispatch_def.company is '法人';
comment on column ${iol_schema}.ncbs_tb_dispatch_def.contra_event_type is '对手事件类型';
comment on column ${iol_schema}.ncbs_tb_dispatch_def.contra_tran_type is '对手交易类型';
comment on column ${iol_schema}.ncbs_tb_dispatch_def.cv_flag is '现金/凭证标志';
comment on column ${iol_schema}.ncbs_tb_dispatch_def.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_tb_dispatch_def.move_type is '转移类型';
comment on column ${iol_schema}.ncbs_tb_dispatch_def.post_flag is '是否生成分录';
comment on column ${iol_schema}.ncbs_tb_dispatch_def.seq_no is '序号';
comment on column ${iol_schema}.ncbs_tb_dispatch_def.tran_desc is '交易描述';
comment on column ${iol_schema}.ncbs_tb_dispatch_def.use_by_order_flag is '是否按顺序使用';
comment on column ${iol_schema}.ncbs_tb_dispatch_def.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_dispatch_def.contra_branch_type is '对方机构类型';
comment on column ${iol_schema}.ncbs_tb_dispatch_def.dispatch_option is '调拨业务标记';
comment on column ${iol_schema}.ncbs_tb_dispatch_def.inout_confirm_flag is '出入库确认标志';
comment on column ${iol_schema}.ncbs_tb_dispatch_def.confirm_event_type is '确认事件类型';
comment on column ${iol_schema}.ncbs_tb_dispatch_def.confirm_tran_type is '确认交易类型';
comment on column ${iol_schema}.ncbs_tb_dispatch_def.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_dispatch_def.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_dispatch_def.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_dispatch_def.etl_timestamp is 'ETL处理时间戳';
