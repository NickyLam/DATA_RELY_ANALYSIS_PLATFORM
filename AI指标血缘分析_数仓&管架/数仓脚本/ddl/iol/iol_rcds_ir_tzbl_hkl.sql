/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_tzbl_hkl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_tzbl_hkl
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_tzbl_hkl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_tzbl_hkl(
    key_id varchar2(60) -- 主键
    ,loan_no varchar2(60) -- 借据号
    ,data_dt varchar2(10) -- 数据日期
    ,loan_biz_type_cd varchar2(30) -- 业务品种代码
    ,var0301 number(11,7) -- 当前月实际还款率
    ,var0302 number(11,7) -- 过去3个月实际还款率的最小值
    ,var0303 number(11,7) -- 过去6个月实际还款率的最小值
    ,var0304 number(11,7) -- 过去12个月实际还款率的最小值
    ,var0305 number(11,7) -- 过去3个月实际还款率的最大值
    ,var0306 number(11,7) -- 过去6个月实际还款率的最大值
    ,var0307 number(11,7) -- 过去12个月实际还款率的最大值
    ,var0308 number(11,7) -- 过去3个月实际还款率的平均值
    ,var0309 number(11,7) -- 过去6个月实际还款率的平均值
    ,var0310 number(11,7) -- 过去12个月实际还款率的平均值
    ,var0311 number(22) -- 过去3个月实际还款率大于50%的月数
    ,var0312 number(22) -- 过去6个月实际还款率大于50%的月数
    ,var0313 number(22) -- 过去12个月实际还款率大于50%的月数
    ,var0314 number(22) -- 过去12个月实际还款率大于50%的距今月数
    ,var0315 number(22) -- 过去3个月实际还款率大于75%的月数
    ,var0316 number(22) -- 过去6个月实际还款率大于75%的月数
    ,var0317 number(22) -- 过去12个月实际还款率大于75%的月数
    ,var0318 number(22) -- 过去12个月实际还款率大于75%的距今月数
    ,var0319 number(22) -- 过去3个月实际还款率大于90%的月数
    ,var0320 number(22) -- 过去6个月实际还款率大于90%的月数
    ,var0321 number(22) -- 过去12个月实际还款率大于90%的月数
    ,var0322 number(22) -- 过去12个月实际还款率大于90%的距今月数
    ,var0323 number(22) -- 过去3个月实际还款率大于等于100%的月数
    ,var0324 number(22) -- 过去6个月实际还款率大于等于100%的月数
    ,var0325 number(22) -- 过去12个月实际还款率大于等于100%的月数
    ,var0326 number(22) -- 过去12个月实际还款率大于等于100%的距今月数
    ,var0327 number(22) -- 过去3个月实际还款率小于10%的月数
    ,var0328 number(22) -- 过去6个月实际还款率小于10%的月数
    ,var0329 number(22) -- 过去12个月实际还款率小于10%的月数
    ,var0330 number(22) -- 过去12个月实际还款率小于10%的距今月数
    ,var0331 number(22) -- 过去3个月实际还款率小于25%的月数
    ,var0332 number(22) -- 过去6个月实际还款率小于25%的月数
    ,var0333 number(22) -- 过去12个月实际还款率小于25%的月数
    ,var0334 number(22) -- 过去12个月实际还款率小于25%的距今月数
    ,var0335 number(22) -- 过去3个月实际还款率小于50%的月数
    ,var0336 number(22) -- 过去6个月实际还款率小于50%的月数
    ,var0337 number(22) -- 过去12个月实际还款率小于50%的月数
    ,var0338 number(22) -- 过去12个月实际还款率小于50%的距今月数
    ,var0339 number(22) -- 过去3个月实际还款率等于0%的月数
    ,var0340 number(22) -- 过去6个月实际还款率等于0%的月数
    ,var0341 number(22) -- 过去12个月实际还款率等于0%的月数
    ,var0342 number(22) -- 过去12个月实际还款率等于0%的距今月数
    ,var0343 number(22) -- 过去3个月还款率连续增加月份数
    ,var0344 number(22) -- 过去6个月还款率连续增加月份数
    ,var0345 number(22) -- 过去12个月还款率连续增加月份数
    ,var0346 number(22) -- 过去3个月还款率连续减少月份数
    ,var0347 number(22) -- 过去6个月还款率连续减少月份数
    ,var0348 number(22) -- 过去12个月还款率连续减少月份数
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
grant select on ${iol_schema}.rcds_ir_tzbl_hkl to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_hkl to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_hkl to ${idl_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_hkl to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_tzbl_hkl is '特征变量表_还款率';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.key_id is '主键';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.loan_no is '借据号';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.data_dt is '数据日期';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.loan_biz_type_cd is '业务品种代码';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0301 is '当前月实际还款率';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0302 is '过去3个月实际还款率的最小值';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0303 is '过去6个月实际还款率的最小值';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0304 is '过去12个月实际还款率的最小值';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0305 is '过去3个月实际还款率的最大值';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0306 is '过去6个月实际还款率的最大值';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0307 is '过去12个月实际还款率的最大值';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0308 is '过去3个月实际还款率的平均值';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0309 is '过去6个月实际还款率的平均值';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0310 is '过去12个月实际还款率的平均值';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0311 is '过去3个月实际还款率大于50%的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0312 is '过去6个月实际还款率大于50%的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0313 is '过去12个月实际还款率大于50%的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0314 is '过去12个月实际还款率大于50%的距今月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0315 is '过去3个月实际还款率大于75%的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0316 is '过去6个月实际还款率大于75%的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0317 is '过去12个月实际还款率大于75%的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0318 is '过去12个月实际还款率大于75%的距今月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0319 is '过去3个月实际还款率大于90%的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0320 is '过去6个月实际还款率大于90%的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0321 is '过去12个月实际还款率大于90%的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0322 is '过去12个月实际还款率大于90%的距今月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0323 is '过去3个月实际还款率大于等于100%的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0324 is '过去6个月实际还款率大于等于100%的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0325 is '过去12个月实际还款率大于等于100%的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0326 is '过去12个月实际还款率大于等于100%的距今月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0327 is '过去3个月实际还款率小于10%的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0328 is '过去6个月实际还款率小于10%的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0329 is '过去12个月实际还款率小于10%的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0330 is '过去12个月实际还款率小于10%的距今月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0331 is '过去3个月实际还款率小于25%的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0332 is '过去6个月实际还款率小于25%的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0333 is '过去12个月实际还款率小于25%的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0334 is '过去12个月实际还款率小于25%的距今月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0335 is '过去3个月实际还款率小于50%的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0336 is '过去6个月实际还款率小于50%的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0337 is '过去12个月实际还款率小于50%的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0338 is '过去12个月实际还款率小于50%的距今月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0339 is '过去3个月实际还款率等于0%的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0340 is '过去6个月实际还款率等于0%的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0341 is '过去12个月实际还款率等于0%的月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0342 is '过去12个月实际还款率等于0%的距今月数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0343 is '过去3个月还款率连续增加月份数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0344 is '过去6个月还款率连续增加月份数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0345 is '过去12个月还款率连续增加月份数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0346 is '过去3个月还款率连续减少月份数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0347 is '过去6个月还款率连续减少月份数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.var0348 is '过去12个月还款率连续减少月份数';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.start_dt is '开始时间';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.end_dt is '结束时间';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.id_mark is '增删标志';
comment on column ${iol_schema}.rcds_ir_tzbl_hkl.etl_timestamp is 'ETL处理时间戳';
