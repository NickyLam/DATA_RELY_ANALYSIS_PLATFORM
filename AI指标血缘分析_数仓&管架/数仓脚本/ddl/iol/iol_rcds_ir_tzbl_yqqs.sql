/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_tzbl_yqqs
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_tzbl_yqqs
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_tzbl_yqqs purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_tzbl_yqqs(
    key_id varchar2(60) -- 主键
    ,loan_no varchar2(60) -- 借据号
    ,data_dt varchar2(10) -- 数据日期
    ,loan_biz_type_cd varchar2(30) -- 业务品种代码
    ,var0401 number(22) -- 当前月逾期期数
    ,var0402 number(22) -- 过去3个月逾期期数最大值
    ,var0403 number(22) -- 过去6个月逾期期数最大值
    ,var0404 number(22) -- 过去12个月逾期期数最大值
    ,var0405 number(22) -- 过去3个月1期及以上逾期的次数
    ,var0406 number(22) -- 过去6个月1期及以上逾期的次数
    ,var0407 number(22) -- 过去12个月1期及以上逾期的次数
    ,var0408 number(22) -- 过去3个月1期及以上逾期最后一次的距今月数
    ,var0409 number(22) -- 过去6个月1期及以上逾期最后一次的距今月数
    ,var0410 number(22) -- 过去12个月1期及以上逾期最后一次的距今月数
    ,var0411 number(22) -- 过去3个月2期及以上逾期的次数
    ,var0412 number(22) -- 过去6个月2期及以上逾期的次数
    ,var0413 number(22) -- 过去12个月2期及以上逾期的次数
    ,var0414 number(22) -- 过去3个月2期及以上逾期最后一次的距今月数
    ,var0415 number(22) -- 过去6个月2期及以上逾期最后一次的距今月数
    ,var0416 number(22) -- 过去12个月2期及以上逾期最后一次的距今月数
    ,var0417 number(22) -- 过去3个月3期及以上逾期的次数
    ,var0418 number(22) -- 过去6个月3期及以上逾期的次数
    ,var0419 number(22) -- 过去12个月3期及以上逾期的次数
    ,var0420 number(22) -- 过去3个月3期及以上逾期最后一次的距今月数
    ,var0421 number(22) -- 过去6个月3期及以上逾期最后一次的距今月数
    ,var0422 number(22) -- 过去12个月3期及以上逾期最后一次的距今月数
    ,var0423 number(22) -- 过去3个月4期及以上逾期的次数
    ,var0424 number(22) -- 过去6个月4期及以上逾期的次数
    ,var0425 number(22) -- 过去12个月4期及以上逾期的次数
    ,var0426 number(22) -- 过去3个月4期及以上逾期最后一次的距今月数
    ,var0427 number(22) -- 过去6个月4期及以上逾期最后一次的距今月数
    ,var0428 number(22) -- 过去12个月4期及以上逾期最后一次的距今月数
    ,var0429 number(22) -- 过去3个月内最长连续未逾期月数
    ,var0430 number(22) -- 过去6个月内最长连续未逾期月数
    ,var0431 number(22) -- 过去12个月内最长连续未逾期月数
    ,var0432 number(22) -- 过去3个月内最长连续逾期月数
    ,var0433 number(22) -- 过去6个月内最长连续逾期月数
    ,var0434 number(22) -- 过去12个月内最长连续逾期月数
    ,var0435 number(22) -- 过去3个月内逾期并且逾期期数连续增加的月数
    ,var0436 number(22) -- 过去6个月内逾期并且逾期期数连续增加的月数
    ,var0437 number(22) -- 过去12个月内逾期并且逾期期数连续增加的月数
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rcds_ir_tzbl_yqqs to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_yqqs to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_yqqs to ${idl_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_yqqs to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_tzbl_yqqs is '特征变量表_逾期期数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.key_id is '主键';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.loan_no is '借据号';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.data_dt is '数据日期';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.loan_biz_type_cd is '业务品种代码';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0401 is '当前月逾期期数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0402 is '过去3个月逾期期数最大值';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0403 is '过去6个月逾期期数最大值';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0404 is '过去12个月逾期期数最大值';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0405 is '过去3个月1期及以上逾期的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0406 is '过去6个月1期及以上逾期的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0407 is '过去12个月1期及以上逾期的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0408 is '过去3个月1期及以上逾期最后一次的距今月数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0409 is '过去6个月1期及以上逾期最后一次的距今月数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0410 is '过去12个月1期及以上逾期最后一次的距今月数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0411 is '过去3个月2期及以上逾期的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0412 is '过去6个月2期及以上逾期的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0413 is '过去12个月2期及以上逾期的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0414 is '过去3个月2期及以上逾期最后一次的距今月数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0415 is '过去6个月2期及以上逾期最后一次的距今月数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0416 is '过去12个月2期及以上逾期最后一次的距今月数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0417 is '过去3个月3期及以上逾期的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0418 is '过去6个月3期及以上逾期的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0419 is '过去12个月3期及以上逾期的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0420 is '过去3个月3期及以上逾期最后一次的距今月数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0421 is '过去6个月3期及以上逾期最后一次的距今月数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0422 is '过去12个月3期及以上逾期最后一次的距今月数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0423 is '过去3个月4期及以上逾期的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0424 is '过去6个月4期及以上逾期的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0425 is '过去12个月4期及以上逾期的次数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0426 is '过去3个月4期及以上逾期最后一次的距今月数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0427 is '过去6个月4期及以上逾期最后一次的距今月数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0428 is '过去12个月4期及以上逾期最后一次的距今月数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0429 is '过去3个月内最长连续未逾期月数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0430 is '过去6个月内最长连续未逾期月数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0431 is '过去12个月内最长连续未逾期月数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0432 is '过去3个月内最长连续逾期月数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0433 is '过去6个月内最长连续逾期月数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0434 is '过去12个月内最长连续逾期月数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0435 is '过去3个月内逾期并且逾期期数连续增加的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0436 is '过去6个月内逾期并且逾期期数连续增加的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.var0437 is '过去12个月内逾期并且逾期期数连续增加的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.start_dt is '开始时间';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.end_dt is '结束时间';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.id_mark is '增删标志';
comment on column ${iol_schema}.rcds_ir_tzbl_yqqs.etl_timestamp is 'ETL处理时间戳';
