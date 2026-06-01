/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_rcd_ir_tzbl_yqje
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_rcd_ir_tzbl_yqje
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_rcd_ir_tzbl_yqje purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_rcd_ir_tzbl_yqje(
    key_id varchar2(60) -- 主键
    ,loan_no varchar2(60) -- 借据号
    ,data_dt varchar2(10) -- 数据日期
    ,loan_biz_type_cd varchar2(30) -- 业务品种代码
    ,var0501 number(18,4) -- 当前月逾期金额
    ,var0502 number(18,4) -- 过去3个月逾期金额的平均值
    ,var0503 number(18,4) -- 过去6个月逾期金额的平均值
    ,var0504 number(18,4) -- 过去12个月逾期金额的平均值
    ,var0505 number(18,4) -- 过去3个月逾期金额的总和
    ,var0506 number(18,4) -- 过去6个月逾期金额的总和
    ,var0507 number(18,4) -- 过去12个月逾期金额的总和
    ,var0508 number(18,4) -- 过去3个月逾期金额最大值
    ,var0509 number(18,4) -- 过去6个月逾期金额最大值
    ,var0510 number(18,4) -- 过去12个月逾期金额最大值
    ,var0511 number -- 过去3个月逾期金额>0的次数
    ,var0512 number -- 过去6个月逾期金额>0的次数
    ,var0513 number -- 过去12个月逾期金额>0的次数
    ,var0514 number -- 过去3个月逾期金额最后一次>0的距今月数
    ,var0515 number -- 过去6个月逾期金额最后一次>0的距今月数
    ,var0516 number -- 过去12个月逾期金额最后一次>0的距今月数
    ,var0517 number -- 过去3个月逾期金额连续增加月份数
    ,var0518 number -- 过去6个月逾期金额连续增加月份数
    ,var0519 number -- 过去12个月逾期金额连续增加月份数
    ,var0520 number(18,4) -- 过去3个月逾期1期以上（含）之逾期金额的最大值
    ,var0521 number(18,4) -- 过去3个月逾期1期以上（含）之逾期金额的平均值
    ,var0522 number(18,4) -- 过去3个月逾期1期以上（含）之逾期金额的总和
    ,var0523 number(18,4) -- 过去6个月逾期1期以上（含）之逾期金额的最大值
    ,var0524 number(18,4) -- 过去6个月逾期1期以上（含）之逾期金额的平均值
    ,var0525 number(18,4) -- 过去6个月逾期1期以上（含）之逾期金额的总和
    ,var0526 number(18,4) -- 过去12个月逾期1期以上（含）之逾期金额的最大值
    ,var0527 number(18,4) -- 过去12个月逾期1期以上（含）之逾期金额的平均值
    ,var0528 number(18,4) -- 过去12个月逾期1期以上（含）之逾期金额的总和
    ,var0529 number(18,4) -- 过去3个月逾期2期以上（含）之逾期金额的最大值
    ,var0530 number(18,4) -- 过去3个月逾期2期以上（含）之逾期金额的平均值
    ,var0531 number(18,4) -- 过去3个月逾期2期以上（含）之逾期金额的总和
    ,var0532 number(18,4) -- 过去6个月逾期2期以上（含）之逾期金额的最大值
    ,var0533 number(18,4) -- 过去6个月逾期2期以上（含）之逾期金额的平均值
    ,var0534 number(18,4) -- 过去6个月逾期2期以上（含）之逾期金额的总和
    ,var0535 number(18,4) -- 过去12个月逾期2期以上（含）之逾期金额的最大值
    ,var0536 number(18,4) -- 过去12个月逾期2期以上（含）之逾期金额的平均值
    ,var0537 number(18,4) -- 过去12个月逾期2期以上（含）之逾期金额的总和
    ,var0538 number(18,4) -- 过去3个月逾期3期以上（含）之逾期金额的最大值
    ,var0539 number(18,4) -- 过去3个月逾期3期以上（含）之逾期金额的平均值
    ,var0540 number(18,4) -- 过去3个月逾期3期以上（含）之逾期金额的总和
    ,var0541 number(18,4) -- 过去6个月逾期3期以上（含）之逾期金额的最大值
    ,var0542 number(18,4) -- 过去6个月逾期3期以上（含）之逾期金额的平均值
    ,var0543 number(18,4) -- 过去6个月逾期3期以上（含）之逾期金额的总和
    ,var0544 number(18,4) -- 过去12个月逾期3期以上（含）之逾期金额的最大值
    ,var0545 number(18,4) -- 过去12个月逾期3期以上（含）之逾期金额的平均值
    ,var0546 number(18,4) -- 过去12个月逾期3期以上（含）之逾期金额的总和
    ,var0547 number(18,4) -- 过去3个月逾期4期以上（含）之逾期金额的最大值
    ,var0548 number(18,4) -- 过去3个月逾期4期以上（含）之逾期金额的平均值
    ,var0549 number(18,4) -- 过去3个月逾期4期以上（含）之逾期金额的总和
    ,var0550 number(18,4) -- 过去6个月逾期4期以上（含）之逾期金额的最大值
    ,var0551 number(18,4) -- 过去6个月逾期4期以上（含）之逾期金额的平均值
    ,var0552 number(18,4) -- 过去6个月逾期4期以上（含）之逾期金额的总和
    ,var0553 number(18,4) -- 过去12个月逾期4期以上（含）之逾期金额的最大值
    ,var0554 number(18,4) -- 过去12个月逾期4期以上（含）之逾期金额的平均值
    ,var0555 number(18,4) -- 过去12个月逾期4期以上（含）之逾期金额的总和
    ,exc_id varchar2(60) -- 执行清单表ID
    ,generated_time date -- 生成时间
    ,partition_month varchar2(60) -- 分区月份
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
grant select on ${iol_schema}.rsts_rcd_ir_tzbl_yqje to ${iml_schema};
grant select on ${iol_schema}.rsts_rcd_ir_tzbl_yqje to ${icl_schema};
grant select on ${iol_schema}.rsts_rcd_ir_tzbl_yqje to ${idl_schema};
grant select on ${iol_schema}.rsts_rcd_ir_tzbl_yqje to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_rcd_ir_tzbl_yqje is '特征变量表_逾期金额';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.key_id is '主键';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.loan_no is '借据号';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.data_dt is '数据日期';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.loan_biz_type_cd is '业务品种代码';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0501 is '当前月逾期金额';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0502 is '过去3个月逾期金额的平均值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0503 is '过去6个月逾期金额的平均值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0504 is '过去12个月逾期金额的平均值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0505 is '过去3个月逾期金额的总和';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0506 is '过去6个月逾期金额的总和';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0507 is '过去12个月逾期金额的总和';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0508 is '过去3个月逾期金额最大值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0509 is '过去6个月逾期金额最大值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0510 is '过去12个月逾期金额最大值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0511 is '过去3个月逾期金额>0的次数';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0512 is '过去6个月逾期金额>0的次数';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0513 is '过去12个月逾期金额>0的次数';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0514 is '过去3个月逾期金额最后一次>0的距今月数';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0515 is '过去6个月逾期金额最后一次>0的距今月数';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0516 is '过去12个月逾期金额最后一次>0的距今月数';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0517 is '过去3个月逾期金额连续增加月份数';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0518 is '过去6个月逾期金额连续增加月份数';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0519 is '过去12个月逾期金额连续增加月份数';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0520 is '过去3个月逾期1期以上（含）之逾期金额的最大值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0521 is '过去3个月逾期1期以上（含）之逾期金额的平均值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0522 is '过去3个月逾期1期以上（含）之逾期金额的总和';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0523 is '过去6个月逾期1期以上（含）之逾期金额的最大值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0524 is '过去6个月逾期1期以上（含）之逾期金额的平均值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0525 is '过去6个月逾期1期以上（含）之逾期金额的总和';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0526 is '过去12个月逾期1期以上（含）之逾期金额的最大值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0527 is '过去12个月逾期1期以上（含）之逾期金额的平均值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0528 is '过去12个月逾期1期以上（含）之逾期金额的总和';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0529 is '过去3个月逾期2期以上（含）之逾期金额的最大值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0530 is '过去3个月逾期2期以上（含）之逾期金额的平均值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0531 is '过去3个月逾期2期以上（含）之逾期金额的总和';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0532 is '过去6个月逾期2期以上（含）之逾期金额的最大值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0533 is '过去6个月逾期2期以上（含）之逾期金额的平均值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0534 is '过去6个月逾期2期以上（含）之逾期金额的总和';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0535 is '过去12个月逾期2期以上（含）之逾期金额的最大值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0536 is '过去12个月逾期2期以上（含）之逾期金额的平均值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0537 is '过去12个月逾期2期以上（含）之逾期金额的总和';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0538 is '过去3个月逾期3期以上（含）之逾期金额的最大值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0539 is '过去3个月逾期3期以上（含）之逾期金额的平均值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0540 is '过去3个月逾期3期以上（含）之逾期金额的总和';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0541 is '过去6个月逾期3期以上（含）之逾期金额的最大值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0542 is '过去6个月逾期3期以上（含）之逾期金额的平均值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0543 is '过去6个月逾期3期以上（含）之逾期金额的总和';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0544 is '过去12个月逾期3期以上（含）之逾期金额的最大值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0545 is '过去12个月逾期3期以上（含）之逾期金额的平均值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0546 is '过去12个月逾期3期以上（含）之逾期金额的总和';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0547 is '过去3个月逾期4期以上（含）之逾期金额的最大值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0548 is '过去3个月逾期4期以上（含）之逾期金额的平均值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0549 is '过去3个月逾期4期以上（含）之逾期金额的总和';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0550 is '过去6个月逾期4期以上（含）之逾期金额的最大值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0551 is '过去6个月逾期4期以上（含）之逾期金额的平均值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0552 is '过去6个月逾期4期以上（含）之逾期金额的总和';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0553 is '过去12个月逾期4期以上（含）之逾期金额的最大值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0554 is '过去12个月逾期4期以上（含）之逾期金额的平均值';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.var0555 is '过去12个月逾期4期以上（含）之逾期金额的总和';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.exc_id is '执行清单表ID';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.generated_time is '生成时间';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.partition_month is '分区月份';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rsts_rcd_ir_tzbl_yqje.etl_timestamp is 'ETL处理时间戳';
