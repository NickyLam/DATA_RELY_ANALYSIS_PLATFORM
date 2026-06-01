/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcds_ir_tzbl_hkl
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.rcds_ir_tzbl_hkl_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rcds_ir_tzbl_hkl;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_tzbl_hkl_op purge;
drop table ${iol_schema}.rcds_ir_tzbl_hkl_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_tzbl_hkl_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_tzbl_hkl where 0=1;

create table ${iol_schema}.rcds_ir_tzbl_hkl_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_tzbl_hkl where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_tzbl_hkl_cl(
            key_id -- 主键
            ,loan_no -- 借据号
            ,data_dt -- 数据日期
            ,loan_biz_type_cd -- 业务品种代码
            ,var0301 -- 当前月实际还款率
            ,var0302 -- 过去3个月实际还款率的最小值
            ,var0303 -- 过去6个月实际还款率的最小值
            ,var0304 -- 过去12个月实际还款率的最小值
            ,var0305 -- 过去3个月实际还款率的最大值
            ,var0306 -- 过去6个月实际还款率的最大值
            ,var0307 -- 过去12个月实际还款率的最大值
            ,var0308 -- 过去3个月实际还款率的平均值
            ,var0309 -- 过去6个月实际还款率的平均值
            ,var0310 -- 过去12个月实际还款率的平均值
            ,var0311 -- 过去3个月实际还款率大于50%的月数
            ,var0312 -- 过去6个月实际还款率大于50%的月数
            ,var0313 -- 过去12个月实际还款率大于50%的月数
            ,var0314 -- 过去12个月实际还款率大于50%的距今月数
            ,var0315 -- 过去3个月实际还款率大于75%的月数
            ,var0316 -- 过去6个月实际还款率大于75%的月数
            ,var0317 -- 过去12个月实际还款率大于75%的月数
            ,var0318 -- 过去12个月实际还款率大于75%的距今月数
            ,var0319 -- 过去3个月实际还款率大于90%的月数
            ,var0320 -- 过去6个月实际还款率大于90%的月数
            ,var0321 -- 过去12个月实际还款率大于90%的月数
            ,var0322 -- 过去12个月实际还款率大于90%的距今月数
            ,var0323 -- 过去3个月实际还款率大于等于100%的月数
            ,var0324 -- 过去6个月实际还款率大于等于100%的月数
            ,var0325 -- 过去12个月实际还款率大于等于100%的月数
            ,var0326 -- 过去12个月实际还款率大于等于100%的距今月数
            ,var0327 -- 过去3个月实际还款率小于10%的月数
            ,var0328 -- 过去6个月实际还款率小于10%的月数
            ,var0329 -- 过去12个月实际还款率小于10%的月数
            ,var0330 -- 过去12个月实际还款率小于10%的距今月数
            ,var0331 -- 过去3个月实际还款率小于25%的月数
            ,var0332 -- 过去6个月实际还款率小于25%的月数
            ,var0333 -- 过去12个月实际还款率小于25%的月数
            ,var0334 -- 过去12个月实际还款率小于25%的距今月数
            ,var0335 -- 过去3个月实际还款率小于50%的月数
            ,var0336 -- 过去6个月实际还款率小于50%的月数
            ,var0337 -- 过去12个月实际还款率小于50%的月数
            ,var0338 -- 过去12个月实际还款率小于50%的距今月数
            ,var0339 -- 过去3个月实际还款率等于0%的月数
            ,var0340 -- 过去6个月实际还款率等于0%的月数
            ,var0341 -- 过去12个月实际还款率等于0%的月数
            ,var0342 -- 过去12个月实际还款率等于0%的距今月数
            ,var0343 -- 过去3个月还款率连续增加月份数
            ,var0344 -- 过去6个月还款率连续增加月份数
            ,var0345 -- 过去12个月还款率连续增加月份数
            ,var0346 -- 过去3个月还款率连续减少月份数
            ,var0347 -- 过去6个月还款率连续减少月份数
            ,var0348 -- 过去12个月还款率连续减少月份数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_tzbl_hkl_op(
            key_id -- 主键
            ,loan_no -- 借据号
            ,data_dt -- 数据日期
            ,loan_biz_type_cd -- 业务品种代码
            ,var0301 -- 当前月实际还款率
            ,var0302 -- 过去3个月实际还款率的最小值
            ,var0303 -- 过去6个月实际还款率的最小值
            ,var0304 -- 过去12个月实际还款率的最小值
            ,var0305 -- 过去3个月实际还款率的最大值
            ,var0306 -- 过去6个月实际还款率的最大值
            ,var0307 -- 过去12个月实际还款率的最大值
            ,var0308 -- 过去3个月实际还款率的平均值
            ,var0309 -- 过去6个月实际还款率的平均值
            ,var0310 -- 过去12个月实际还款率的平均值
            ,var0311 -- 过去3个月实际还款率大于50%的月数
            ,var0312 -- 过去6个月实际还款率大于50%的月数
            ,var0313 -- 过去12个月实际还款率大于50%的月数
            ,var0314 -- 过去12个月实际还款率大于50%的距今月数
            ,var0315 -- 过去3个月实际还款率大于75%的月数
            ,var0316 -- 过去6个月实际还款率大于75%的月数
            ,var0317 -- 过去12个月实际还款率大于75%的月数
            ,var0318 -- 过去12个月实际还款率大于75%的距今月数
            ,var0319 -- 过去3个月实际还款率大于90%的月数
            ,var0320 -- 过去6个月实际还款率大于90%的月数
            ,var0321 -- 过去12个月实际还款率大于90%的月数
            ,var0322 -- 过去12个月实际还款率大于90%的距今月数
            ,var0323 -- 过去3个月实际还款率大于等于100%的月数
            ,var0324 -- 过去6个月实际还款率大于等于100%的月数
            ,var0325 -- 过去12个月实际还款率大于等于100%的月数
            ,var0326 -- 过去12个月实际还款率大于等于100%的距今月数
            ,var0327 -- 过去3个月实际还款率小于10%的月数
            ,var0328 -- 过去6个月实际还款率小于10%的月数
            ,var0329 -- 过去12个月实际还款率小于10%的月数
            ,var0330 -- 过去12个月实际还款率小于10%的距今月数
            ,var0331 -- 过去3个月实际还款率小于25%的月数
            ,var0332 -- 过去6个月实际还款率小于25%的月数
            ,var0333 -- 过去12个月实际还款率小于25%的月数
            ,var0334 -- 过去12个月实际还款率小于25%的距今月数
            ,var0335 -- 过去3个月实际还款率小于50%的月数
            ,var0336 -- 过去6个月实际还款率小于50%的月数
            ,var0337 -- 过去12个月实际还款率小于50%的月数
            ,var0338 -- 过去12个月实际还款率小于50%的距今月数
            ,var0339 -- 过去3个月实际还款率等于0%的月数
            ,var0340 -- 过去6个月实际还款率等于0%的月数
            ,var0341 -- 过去12个月实际还款率等于0%的月数
            ,var0342 -- 过去12个月实际还款率等于0%的距今月数
            ,var0343 -- 过去3个月还款率连续增加月份数
            ,var0344 -- 过去6个月还款率连续增加月份数
            ,var0345 -- 过去12个月还款率连续增加月份数
            ,var0346 -- 过去3个月还款率连续减少月份数
            ,var0347 -- 过去6个月还款率连续减少月份数
            ,var0348 -- 过去12个月还款率连续减少月份数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.key_id, o.key_id) as key_id -- 主键
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 借据号
    ,nvl(n.data_dt, o.data_dt) as data_dt -- 数据日期
    ,nvl(n.loan_biz_type_cd, o.loan_biz_type_cd) as loan_biz_type_cd -- 业务品种代码
    ,nvl(n.var0301, o.var0301) as var0301 -- 当前月实际还款率
    ,nvl(n.var0302, o.var0302) as var0302 -- 过去3个月实际还款率的最小值
    ,nvl(n.var0303, o.var0303) as var0303 -- 过去6个月实际还款率的最小值
    ,nvl(n.var0304, o.var0304) as var0304 -- 过去12个月实际还款率的最小值
    ,nvl(n.var0305, o.var0305) as var0305 -- 过去3个月实际还款率的最大值
    ,nvl(n.var0306, o.var0306) as var0306 -- 过去6个月实际还款率的最大值
    ,nvl(n.var0307, o.var0307) as var0307 -- 过去12个月实际还款率的最大值
    ,nvl(n.var0308, o.var0308) as var0308 -- 过去3个月实际还款率的平均值
    ,nvl(n.var0309, o.var0309) as var0309 -- 过去6个月实际还款率的平均值
    ,nvl(n.var0310, o.var0310) as var0310 -- 过去12个月实际还款率的平均值
    ,nvl(n.var0311, o.var0311) as var0311 -- 过去3个月实际还款率大于50%的月数
    ,nvl(n.var0312, o.var0312) as var0312 -- 过去6个月实际还款率大于50%的月数
    ,nvl(n.var0313, o.var0313) as var0313 -- 过去12个月实际还款率大于50%的月数
    ,nvl(n.var0314, o.var0314) as var0314 -- 过去12个月实际还款率大于50%的距今月数
    ,nvl(n.var0315, o.var0315) as var0315 -- 过去3个月实际还款率大于75%的月数
    ,nvl(n.var0316, o.var0316) as var0316 -- 过去6个月实际还款率大于75%的月数
    ,nvl(n.var0317, o.var0317) as var0317 -- 过去12个月实际还款率大于75%的月数
    ,nvl(n.var0318, o.var0318) as var0318 -- 过去12个月实际还款率大于75%的距今月数
    ,nvl(n.var0319, o.var0319) as var0319 -- 过去3个月实际还款率大于90%的月数
    ,nvl(n.var0320, o.var0320) as var0320 -- 过去6个月实际还款率大于90%的月数
    ,nvl(n.var0321, o.var0321) as var0321 -- 过去12个月实际还款率大于90%的月数
    ,nvl(n.var0322, o.var0322) as var0322 -- 过去12个月实际还款率大于90%的距今月数
    ,nvl(n.var0323, o.var0323) as var0323 -- 过去3个月实际还款率大于等于100%的月数
    ,nvl(n.var0324, o.var0324) as var0324 -- 过去6个月实际还款率大于等于100%的月数
    ,nvl(n.var0325, o.var0325) as var0325 -- 过去12个月实际还款率大于等于100%的月数
    ,nvl(n.var0326, o.var0326) as var0326 -- 过去12个月实际还款率大于等于100%的距今月数
    ,nvl(n.var0327, o.var0327) as var0327 -- 过去3个月实际还款率小于10%的月数
    ,nvl(n.var0328, o.var0328) as var0328 -- 过去6个月实际还款率小于10%的月数
    ,nvl(n.var0329, o.var0329) as var0329 -- 过去12个月实际还款率小于10%的月数
    ,nvl(n.var0330, o.var0330) as var0330 -- 过去12个月实际还款率小于10%的距今月数
    ,nvl(n.var0331, o.var0331) as var0331 -- 过去3个月实际还款率小于25%的月数
    ,nvl(n.var0332, o.var0332) as var0332 -- 过去6个月实际还款率小于25%的月数
    ,nvl(n.var0333, o.var0333) as var0333 -- 过去12个月实际还款率小于25%的月数
    ,nvl(n.var0334, o.var0334) as var0334 -- 过去12个月实际还款率小于25%的距今月数
    ,nvl(n.var0335, o.var0335) as var0335 -- 过去3个月实际还款率小于50%的月数
    ,nvl(n.var0336, o.var0336) as var0336 -- 过去6个月实际还款率小于50%的月数
    ,nvl(n.var0337, o.var0337) as var0337 -- 过去12个月实际还款率小于50%的月数
    ,nvl(n.var0338, o.var0338) as var0338 -- 过去12个月实际还款率小于50%的距今月数
    ,nvl(n.var0339, o.var0339) as var0339 -- 过去3个月实际还款率等于0%的月数
    ,nvl(n.var0340, o.var0340) as var0340 -- 过去6个月实际还款率等于0%的月数
    ,nvl(n.var0341, o.var0341) as var0341 -- 过去12个月实际还款率等于0%的月数
    ,nvl(n.var0342, o.var0342) as var0342 -- 过去12个月实际还款率等于0%的距今月数
    ,nvl(n.var0343, o.var0343) as var0343 -- 过去3个月还款率连续增加月份数
    ,nvl(n.var0344, o.var0344) as var0344 -- 过去6个月还款率连续增加月份数
    ,nvl(n.var0345, o.var0345) as var0345 -- 过去12个月还款率连续增加月份数
    ,nvl(n.var0346, o.var0346) as var0346 -- 过去3个月还款率连续减少月份数
    ,nvl(n.var0347, o.var0347) as var0347 -- 过去6个月还款率连续减少月份数
    ,nvl(n.var0348, o.var0348) as var0348 -- 过去12个月还款率连续减少月份数
    ,case when
            n.key_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.key_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.key_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rcds_ir_tzbl_hkl_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rcds_ir_tzbl_hkl where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.key_id = n.key_id
where (
        o.key_id is null
    )
    or (
        n.key_id is null
    )
    or (
        o.loan_no <> n.loan_no
        or o.data_dt <> n.data_dt
        or o.loan_biz_type_cd <> n.loan_biz_type_cd
        or o.var0301 <> n.var0301
        or o.var0302 <> n.var0302
        or o.var0303 <> n.var0303
        or o.var0304 <> n.var0304
        or o.var0305 <> n.var0305
        or o.var0306 <> n.var0306
        or o.var0307 <> n.var0307
        or o.var0308 <> n.var0308
        or o.var0309 <> n.var0309
        or o.var0310 <> n.var0310
        or o.var0311 <> n.var0311
        or o.var0312 <> n.var0312
        or o.var0313 <> n.var0313
        or o.var0314 <> n.var0314
        or o.var0315 <> n.var0315
        or o.var0316 <> n.var0316
        or o.var0317 <> n.var0317
        or o.var0318 <> n.var0318
        or o.var0319 <> n.var0319
        or o.var0320 <> n.var0320
        or o.var0321 <> n.var0321
        or o.var0322 <> n.var0322
        or o.var0323 <> n.var0323
        or o.var0324 <> n.var0324
        or o.var0325 <> n.var0325
        or o.var0326 <> n.var0326
        or o.var0327 <> n.var0327
        or o.var0328 <> n.var0328
        or o.var0329 <> n.var0329
        or o.var0330 <> n.var0330
        or o.var0331 <> n.var0331
        or o.var0332 <> n.var0332
        or o.var0333 <> n.var0333
        or o.var0334 <> n.var0334
        or o.var0335 <> n.var0335
        or o.var0336 <> n.var0336
        or o.var0337 <> n.var0337
        or o.var0338 <> n.var0338
        or o.var0339 <> n.var0339
        or o.var0340 <> n.var0340
        or o.var0341 <> n.var0341
        or o.var0342 <> n.var0342
        or o.var0343 <> n.var0343
        or o.var0344 <> n.var0344
        or o.var0345 <> n.var0345
        or o.var0346 <> n.var0346
        or o.var0347 <> n.var0347
        or o.var0348 <> n.var0348
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_tzbl_hkl_cl(
            key_id -- 主键
            ,loan_no -- 借据号
            ,data_dt -- 数据日期
            ,loan_biz_type_cd -- 业务品种代码
            ,var0301 -- 当前月实际还款率
            ,var0302 -- 过去3个月实际还款率的最小值
            ,var0303 -- 过去6个月实际还款率的最小值
            ,var0304 -- 过去12个月实际还款率的最小值
            ,var0305 -- 过去3个月实际还款率的最大值
            ,var0306 -- 过去6个月实际还款率的最大值
            ,var0307 -- 过去12个月实际还款率的最大值
            ,var0308 -- 过去3个月实际还款率的平均值
            ,var0309 -- 过去6个月实际还款率的平均值
            ,var0310 -- 过去12个月实际还款率的平均值
            ,var0311 -- 过去3个月实际还款率大于50%的月数
            ,var0312 -- 过去6个月实际还款率大于50%的月数
            ,var0313 -- 过去12个月实际还款率大于50%的月数
            ,var0314 -- 过去12个月实际还款率大于50%的距今月数
            ,var0315 -- 过去3个月实际还款率大于75%的月数
            ,var0316 -- 过去6个月实际还款率大于75%的月数
            ,var0317 -- 过去12个月实际还款率大于75%的月数
            ,var0318 -- 过去12个月实际还款率大于75%的距今月数
            ,var0319 -- 过去3个月实际还款率大于90%的月数
            ,var0320 -- 过去6个月实际还款率大于90%的月数
            ,var0321 -- 过去12个月实际还款率大于90%的月数
            ,var0322 -- 过去12个月实际还款率大于90%的距今月数
            ,var0323 -- 过去3个月实际还款率大于等于100%的月数
            ,var0324 -- 过去6个月实际还款率大于等于100%的月数
            ,var0325 -- 过去12个月实际还款率大于等于100%的月数
            ,var0326 -- 过去12个月实际还款率大于等于100%的距今月数
            ,var0327 -- 过去3个月实际还款率小于10%的月数
            ,var0328 -- 过去6个月实际还款率小于10%的月数
            ,var0329 -- 过去12个月实际还款率小于10%的月数
            ,var0330 -- 过去12个月实际还款率小于10%的距今月数
            ,var0331 -- 过去3个月实际还款率小于25%的月数
            ,var0332 -- 过去6个月实际还款率小于25%的月数
            ,var0333 -- 过去12个月实际还款率小于25%的月数
            ,var0334 -- 过去12个月实际还款率小于25%的距今月数
            ,var0335 -- 过去3个月实际还款率小于50%的月数
            ,var0336 -- 过去6个月实际还款率小于50%的月数
            ,var0337 -- 过去12个月实际还款率小于50%的月数
            ,var0338 -- 过去12个月实际还款率小于50%的距今月数
            ,var0339 -- 过去3个月实际还款率等于0%的月数
            ,var0340 -- 过去6个月实际还款率等于0%的月数
            ,var0341 -- 过去12个月实际还款率等于0%的月数
            ,var0342 -- 过去12个月实际还款率等于0%的距今月数
            ,var0343 -- 过去3个月还款率连续增加月份数
            ,var0344 -- 过去6个月还款率连续增加月份数
            ,var0345 -- 过去12个月还款率连续增加月份数
            ,var0346 -- 过去3个月还款率连续减少月份数
            ,var0347 -- 过去6个月还款率连续减少月份数
            ,var0348 -- 过去12个月还款率连续减少月份数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_tzbl_hkl_op(
            key_id -- 主键
            ,loan_no -- 借据号
            ,data_dt -- 数据日期
            ,loan_biz_type_cd -- 业务品种代码
            ,var0301 -- 当前月实际还款率
            ,var0302 -- 过去3个月实际还款率的最小值
            ,var0303 -- 过去6个月实际还款率的最小值
            ,var0304 -- 过去12个月实际还款率的最小值
            ,var0305 -- 过去3个月实际还款率的最大值
            ,var0306 -- 过去6个月实际还款率的最大值
            ,var0307 -- 过去12个月实际还款率的最大值
            ,var0308 -- 过去3个月实际还款率的平均值
            ,var0309 -- 过去6个月实际还款率的平均值
            ,var0310 -- 过去12个月实际还款率的平均值
            ,var0311 -- 过去3个月实际还款率大于50%的月数
            ,var0312 -- 过去6个月实际还款率大于50%的月数
            ,var0313 -- 过去12个月实际还款率大于50%的月数
            ,var0314 -- 过去12个月实际还款率大于50%的距今月数
            ,var0315 -- 过去3个月实际还款率大于75%的月数
            ,var0316 -- 过去6个月实际还款率大于75%的月数
            ,var0317 -- 过去12个月实际还款率大于75%的月数
            ,var0318 -- 过去12个月实际还款率大于75%的距今月数
            ,var0319 -- 过去3个月实际还款率大于90%的月数
            ,var0320 -- 过去6个月实际还款率大于90%的月数
            ,var0321 -- 过去12个月实际还款率大于90%的月数
            ,var0322 -- 过去12个月实际还款率大于90%的距今月数
            ,var0323 -- 过去3个月实际还款率大于等于100%的月数
            ,var0324 -- 过去6个月实际还款率大于等于100%的月数
            ,var0325 -- 过去12个月实际还款率大于等于100%的月数
            ,var0326 -- 过去12个月实际还款率大于等于100%的距今月数
            ,var0327 -- 过去3个月实际还款率小于10%的月数
            ,var0328 -- 过去6个月实际还款率小于10%的月数
            ,var0329 -- 过去12个月实际还款率小于10%的月数
            ,var0330 -- 过去12个月实际还款率小于10%的距今月数
            ,var0331 -- 过去3个月实际还款率小于25%的月数
            ,var0332 -- 过去6个月实际还款率小于25%的月数
            ,var0333 -- 过去12个月实际还款率小于25%的月数
            ,var0334 -- 过去12个月实际还款率小于25%的距今月数
            ,var0335 -- 过去3个月实际还款率小于50%的月数
            ,var0336 -- 过去6个月实际还款率小于50%的月数
            ,var0337 -- 过去12个月实际还款率小于50%的月数
            ,var0338 -- 过去12个月实际还款率小于50%的距今月数
            ,var0339 -- 过去3个月实际还款率等于0%的月数
            ,var0340 -- 过去6个月实际还款率等于0%的月数
            ,var0341 -- 过去12个月实际还款率等于0%的月数
            ,var0342 -- 过去12个月实际还款率等于0%的距今月数
            ,var0343 -- 过去3个月还款率连续增加月份数
            ,var0344 -- 过去6个月还款率连续增加月份数
            ,var0345 -- 过去12个月还款率连续增加月份数
            ,var0346 -- 过去3个月还款率连续减少月份数
            ,var0347 -- 过去6个月还款率连续减少月份数
            ,var0348 -- 过去12个月还款率连续减少月份数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.key_id -- 主键
    ,o.loan_no -- 借据号
    ,o.data_dt -- 数据日期
    ,o.loan_biz_type_cd -- 业务品种代码
    ,o.var0301 -- 当前月实际还款率
    ,o.var0302 -- 过去3个月实际还款率的最小值
    ,o.var0303 -- 过去6个月实际还款率的最小值
    ,o.var0304 -- 过去12个月实际还款率的最小值
    ,o.var0305 -- 过去3个月实际还款率的最大值
    ,o.var0306 -- 过去6个月实际还款率的最大值
    ,o.var0307 -- 过去12个月实际还款率的最大值
    ,o.var0308 -- 过去3个月实际还款率的平均值
    ,o.var0309 -- 过去6个月实际还款率的平均值
    ,o.var0310 -- 过去12个月实际还款率的平均值
    ,o.var0311 -- 过去3个月实际还款率大于50%的月数
    ,o.var0312 -- 过去6个月实际还款率大于50%的月数
    ,o.var0313 -- 过去12个月实际还款率大于50%的月数
    ,o.var0314 -- 过去12个月实际还款率大于50%的距今月数
    ,o.var0315 -- 过去3个月实际还款率大于75%的月数
    ,o.var0316 -- 过去6个月实际还款率大于75%的月数
    ,o.var0317 -- 过去12个月实际还款率大于75%的月数
    ,o.var0318 -- 过去12个月实际还款率大于75%的距今月数
    ,o.var0319 -- 过去3个月实际还款率大于90%的月数
    ,o.var0320 -- 过去6个月实际还款率大于90%的月数
    ,o.var0321 -- 过去12个月实际还款率大于90%的月数
    ,o.var0322 -- 过去12个月实际还款率大于90%的距今月数
    ,o.var0323 -- 过去3个月实际还款率大于等于100%的月数
    ,o.var0324 -- 过去6个月实际还款率大于等于100%的月数
    ,o.var0325 -- 过去12个月实际还款率大于等于100%的月数
    ,o.var0326 -- 过去12个月实际还款率大于等于100%的距今月数
    ,o.var0327 -- 过去3个月实际还款率小于10%的月数
    ,o.var0328 -- 过去6个月实际还款率小于10%的月数
    ,o.var0329 -- 过去12个月实际还款率小于10%的月数
    ,o.var0330 -- 过去12个月实际还款率小于10%的距今月数
    ,o.var0331 -- 过去3个月实际还款率小于25%的月数
    ,o.var0332 -- 过去6个月实际还款率小于25%的月数
    ,o.var0333 -- 过去12个月实际还款率小于25%的月数
    ,o.var0334 -- 过去12个月实际还款率小于25%的距今月数
    ,o.var0335 -- 过去3个月实际还款率小于50%的月数
    ,o.var0336 -- 过去6个月实际还款率小于50%的月数
    ,o.var0337 -- 过去12个月实际还款率小于50%的月数
    ,o.var0338 -- 过去12个月实际还款率小于50%的距今月数
    ,o.var0339 -- 过去3个月实际还款率等于0%的月数
    ,o.var0340 -- 过去6个月实际还款率等于0%的月数
    ,o.var0341 -- 过去12个月实际还款率等于0%的月数
    ,o.var0342 -- 过去12个月实际还款率等于0%的距今月数
    ,o.var0343 -- 过去3个月还款率连续增加月份数
    ,o.var0344 -- 过去6个月还款率连续增加月份数
    ,o.var0345 -- 过去12个月还款率连续增加月份数
    ,o.var0346 -- 过去3个月还款率连续减少月份数
    ,o.var0347 -- 过去6个月还款率连续减少月份数
    ,o.var0348 -- 过去12个月还款率连续减少月份数
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.rcds_ir_tzbl_hkl_bk o
    left join ${iol_schema}.rcds_ir_tzbl_hkl_op n
        on
            o.key_id = n.key_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rcds_ir_tzbl_hkl_cl d
        on
            o.key_id = d.key_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.rcds_ir_tzbl_hkl;

-- 4.2 exchange partition
alter table ${iol_schema}.rcds_ir_tzbl_hkl exchange partition p_19000101 with table ${iol_schema}.rcds_ir_tzbl_hkl_cl;
alter table ${iol_schema}.rcds_ir_tzbl_hkl exchange partition p_20991231 with table ${iol_schema}.rcds_ir_tzbl_hkl_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rcds_ir_tzbl_hkl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_tzbl_hkl_op purge;
drop table ${iol_schema}.rcds_ir_tzbl_hkl_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rcds_ir_tzbl_hkl_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rcds_ir_tzbl_hkl',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
