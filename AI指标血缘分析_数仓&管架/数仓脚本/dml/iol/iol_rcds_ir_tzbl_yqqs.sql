/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcds_ir_tzbl_yqqs
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
create table ${iol_schema}.rcds_ir_tzbl_yqqs_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rcds_ir_tzbl_yqqs;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_tzbl_yqqs_op purge;
drop table ${iol_schema}.rcds_ir_tzbl_yqqs_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_tzbl_yqqs_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_tzbl_yqqs where 0=1;

create table ${iol_schema}.rcds_ir_tzbl_yqqs_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_tzbl_yqqs where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_tzbl_yqqs_cl(
            key_id -- 主键
            ,loan_no -- 借据号
            ,data_dt -- 数据日期
            ,loan_biz_type_cd -- 业务品种代码
            ,var0401 -- 当前月逾期期数
            ,var0402 -- 过去3个月逾期期数最大值
            ,var0403 -- 过去6个月逾期期数最大值
            ,var0404 -- 过去12个月逾期期数最大值
            ,var0405 -- 过去3个月1期及以上逾期的次数
            ,var0406 -- 过去6个月1期及以上逾期的次数
            ,var0407 -- 过去12个月1期及以上逾期的次数
            ,var0408 -- 过去3个月1期及以上逾期最后一次的距今月数
            ,var0409 -- 过去6个月1期及以上逾期最后一次的距今月数
            ,var0410 -- 过去12个月1期及以上逾期最后一次的距今月数
            ,var0411 -- 过去3个月2期及以上逾期的次数
            ,var0412 -- 过去6个月2期及以上逾期的次数
            ,var0413 -- 过去12个月2期及以上逾期的次数
            ,var0414 -- 过去3个月2期及以上逾期最后一次的距今月数
            ,var0415 -- 过去6个月2期及以上逾期最后一次的距今月数
            ,var0416 -- 过去12个月2期及以上逾期最后一次的距今月数
            ,var0417 -- 过去3个月3期及以上逾期的次数
            ,var0418 -- 过去6个月3期及以上逾期的次数
            ,var0419 -- 过去12个月3期及以上逾期的次数
            ,var0420 -- 过去3个月3期及以上逾期最后一次的距今月数
            ,var0421 -- 过去6个月3期及以上逾期最后一次的距今月数
            ,var0422 -- 过去12个月3期及以上逾期最后一次的距今月数
            ,var0423 -- 过去3个月4期及以上逾期的次数
            ,var0424 -- 过去6个月4期及以上逾期的次数
            ,var0425 -- 过去12个月4期及以上逾期的次数
            ,var0426 -- 过去3个月4期及以上逾期最后一次的距今月数
            ,var0427 -- 过去6个月4期及以上逾期最后一次的距今月数
            ,var0428 -- 过去12个月4期及以上逾期最后一次的距今月数
            ,var0429 -- 过去3个月内最长连续未逾期月数
            ,var0430 -- 过去6个月内最长连续未逾期月数
            ,var0431 -- 过去12个月内最长连续未逾期月数
            ,var0432 -- 过去3个月内最长连续逾期月数
            ,var0433 -- 过去6个月内最长连续逾期月数
            ,var0434 -- 过去12个月内最长连续逾期月数
            ,var0435 -- 过去3个月内逾期并且逾期期数连续增加的月数
            ,var0436 -- 过去6个月内逾期并且逾期期数连续增加的月数
            ,var0437 -- 过去12个月内逾期并且逾期期数连续增加的月数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_tzbl_yqqs_op(
            key_id -- 主键
            ,loan_no -- 借据号
            ,data_dt -- 数据日期
            ,loan_biz_type_cd -- 业务品种代码
            ,var0401 -- 当前月逾期期数
            ,var0402 -- 过去3个月逾期期数最大值
            ,var0403 -- 过去6个月逾期期数最大值
            ,var0404 -- 过去12个月逾期期数最大值
            ,var0405 -- 过去3个月1期及以上逾期的次数
            ,var0406 -- 过去6个月1期及以上逾期的次数
            ,var0407 -- 过去12个月1期及以上逾期的次数
            ,var0408 -- 过去3个月1期及以上逾期最后一次的距今月数
            ,var0409 -- 过去6个月1期及以上逾期最后一次的距今月数
            ,var0410 -- 过去12个月1期及以上逾期最后一次的距今月数
            ,var0411 -- 过去3个月2期及以上逾期的次数
            ,var0412 -- 过去6个月2期及以上逾期的次数
            ,var0413 -- 过去12个月2期及以上逾期的次数
            ,var0414 -- 过去3个月2期及以上逾期最后一次的距今月数
            ,var0415 -- 过去6个月2期及以上逾期最后一次的距今月数
            ,var0416 -- 过去12个月2期及以上逾期最后一次的距今月数
            ,var0417 -- 过去3个月3期及以上逾期的次数
            ,var0418 -- 过去6个月3期及以上逾期的次数
            ,var0419 -- 过去12个月3期及以上逾期的次数
            ,var0420 -- 过去3个月3期及以上逾期最后一次的距今月数
            ,var0421 -- 过去6个月3期及以上逾期最后一次的距今月数
            ,var0422 -- 过去12个月3期及以上逾期最后一次的距今月数
            ,var0423 -- 过去3个月4期及以上逾期的次数
            ,var0424 -- 过去6个月4期及以上逾期的次数
            ,var0425 -- 过去12个月4期及以上逾期的次数
            ,var0426 -- 过去3个月4期及以上逾期最后一次的距今月数
            ,var0427 -- 过去6个月4期及以上逾期最后一次的距今月数
            ,var0428 -- 过去12个月4期及以上逾期最后一次的距今月数
            ,var0429 -- 过去3个月内最长连续未逾期月数
            ,var0430 -- 过去6个月内最长连续未逾期月数
            ,var0431 -- 过去12个月内最长连续未逾期月数
            ,var0432 -- 过去3个月内最长连续逾期月数
            ,var0433 -- 过去6个月内最长连续逾期月数
            ,var0434 -- 过去12个月内最长连续逾期月数
            ,var0435 -- 过去3个月内逾期并且逾期期数连续增加的月数
            ,var0436 -- 过去6个月内逾期并且逾期期数连续增加的月数
            ,var0437 -- 过去12个月内逾期并且逾期期数连续增加的月数
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
    ,nvl(n.var0401, o.var0401) as var0401 -- 当前月逾期期数
    ,nvl(n.var0402, o.var0402) as var0402 -- 过去3个月逾期期数最大值
    ,nvl(n.var0403, o.var0403) as var0403 -- 过去6个月逾期期数最大值
    ,nvl(n.var0404, o.var0404) as var0404 -- 过去12个月逾期期数最大值
    ,nvl(n.var0405, o.var0405) as var0405 -- 过去3个月1期及以上逾期的次数
    ,nvl(n.var0406, o.var0406) as var0406 -- 过去6个月1期及以上逾期的次数
    ,nvl(n.var0407, o.var0407) as var0407 -- 过去12个月1期及以上逾期的次数
    ,nvl(n.var0408, o.var0408) as var0408 -- 过去3个月1期及以上逾期最后一次的距今月数
    ,nvl(n.var0409, o.var0409) as var0409 -- 过去6个月1期及以上逾期最后一次的距今月数
    ,nvl(n.var0410, o.var0410) as var0410 -- 过去12个月1期及以上逾期最后一次的距今月数
    ,nvl(n.var0411, o.var0411) as var0411 -- 过去3个月2期及以上逾期的次数
    ,nvl(n.var0412, o.var0412) as var0412 -- 过去6个月2期及以上逾期的次数
    ,nvl(n.var0413, o.var0413) as var0413 -- 过去12个月2期及以上逾期的次数
    ,nvl(n.var0414, o.var0414) as var0414 -- 过去3个月2期及以上逾期最后一次的距今月数
    ,nvl(n.var0415, o.var0415) as var0415 -- 过去6个月2期及以上逾期最后一次的距今月数
    ,nvl(n.var0416, o.var0416) as var0416 -- 过去12个月2期及以上逾期最后一次的距今月数
    ,nvl(n.var0417, o.var0417) as var0417 -- 过去3个月3期及以上逾期的次数
    ,nvl(n.var0418, o.var0418) as var0418 -- 过去6个月3期及以上逾期的次数
    ,nvl(n.var0419, o.var0419) as var0419 -- 过去12个月3期及以上逾期的次数
    ,nvl(n.var0420, o.var0420) as var0420 -- 过去3个月3期及以上逾期最后一次的距今月数
    ,nvl(n.var0421, o.var0421) as var0421 -- 过去6个月3期及以上逾期最后一次的距今月数
    ,nvl(n.var0422, o.var0422) as var0422 -- 过去12个月3期及以上逾期最后一次的距今月数
    ,nvl(n.var0423, o.var0423) as var0423 -- 过去3个月4期及以上逾期的次数
    ,nvl(n.var0424, o.var0424) as var0424 -- 过去6个月4期及以上逾期的次数
    ,nvl(n.var0425, o.var0425) as var0425 -- 过去12个月4期及以上逾期的次数
    ,nvl(n.var0426, o.var0426) as var0426 -- 过去3个月4期及以上逾期最后一次的距今月数
    ,nvl(n.var0427, o.var0427) as var0427 -- 过去6个月4期及以上逾期最后一次的距今月数
    ,nvl(n.var0428, o.var0428) as var0428 -- 过去12个月4期及以上逾期最后一次的距今月数
    ,nvl(n.var0429, o.var0429) as var0429 -- 过去3个月内最长连续未逾期月数
    ,nvl(n.var0430, o.var0430) as var0430 -- 过去6个月内最长连续未逾期月数
    ,nvl(n.var0431, o.var0431) as var0431 -- 过去12个月内最长连续未逾期月数
    ,nvl(n.var0432, o.var0432) as var0432 -- 过去3个月内最长连续逾期月数
    ,nvl(n.var0433, o.var0433) as var0433 -- 过去6个月内最长连续逾期月数
    ,nvl(n.var0434, o.var0434) as var0434 -- 过去12个月内最长连续逾期月数
    ,nvl(n.var0435, o.var0435) as var0435 -- 过去3个月内逾期并且逾期期数连续增加的月数
    ,nvl(n.var0436, o.var0436) as var0436 -- 过去6个月内逾期并且逾期期数连续增加的月数
    ,nvl(n.var0437, o.var0437) as var0437 -- 过去12个月内逾期并且逾期期数连续增加的月数
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
from (select * from ${iol_schema}.rcds_ir_tzbl_yqqs_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rcds_ir_tzbl_yqqs where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.var0401 <> n.var0401
        or o.var0402 <> n.var0402
        or o.var0403 <> n.var0403
        or o.var0404 <> n.var0404
        or o.var0405 <> n.var0405
        or o.var0406 <> n.var0406
        or o.var0407 <> n.var0407
        or o.var0408 <> n.var0408
        or o.var0409 <> n.var0409
        or o.var0410 <> n.var0410
        or o.var0411 <> n.var0411
        or o.var0412 <> n.var0412
        or o.var0413 <> n.var0413
        or o.var0414 <> n.var0414
        or o.var0415 <> n.var0415
        or o.var0416 <> n.var0416
        or o.var0417 <> n.var0417
        or o.var0418 <> n.var0418
        or o.var0419 <> n.var0419
        or o.var0420 <> n.var0420
        or o.var0421 <> n.var0421
        or o.var0422 <> n.var0422
        or o.var0423 <> n.var0423
        or o.var0424 <> n.var0424
        or o.var0425 <> n.var0425
        or o.var0426 <> n.var0426
        or o.var0427 <> n.var0427
        or o.var0428 <> n.var0428
        or o.var0429 <> n.var0429
        or o.var0430 <> n.var0430
        or o.var0431 <> n.var0431
        or o.var0432 <> n.var0432
        or o.var0433 <> n.var0433
        or o.var0434 <> n.var0434
        or o.var0435 <> n.var0435
        or o.var0436 <> n.var0436
        or o.var0437 <> n.var0437
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_tzbl_yqqs_cl(
            key_id -- 主键
            ,loan_no -- 借据号
            ,data_dt -- 数据日期
            ,loan_biz_type_cd -- 业务品种代码
            ,var0401 -- 当前月逾期期数
            ,var0402 -- 过去3个月逾期期数最大值
            ,var0403 -- 过去6个月逾期期数最大值
            ,var0404 -- 过去12个月逾期期数最大值
            ,var0405 -- 过去3个月1期及以上逾期的次数
            ,var0406 -- 过去6个月1期及以上逾期的次数
            ,var0407 -- 过去12个月1期及以上逾期的次数
            ,var0408 -- 过去3个月1期及以上逾期最后一次的距今月数
            ,var0409 -- 过去6个月1期及以上逾期最后一次的距今月数
            ,var0410 -- 过去12个月1期及以上逾期最后一次的距今月数
            ,var0411 -- 过去3个月2期及以上逾期的次数
            ,var0412 -- 过去6个月2期及以上逾期的次数
            ,var0413 -- 过去12个月2期及以上逾期的次数
            ,var0414 -- 过去3个月2期及以上逾期最后一次的距今月数
            ,var0415 -- 过去6个月2期及以上逾期最后一次的距今月数
            ,var0416 -- 过去12个月2期及以上逾期最后一次的距今月数
            ,var0417 -- 过去3个月3期及以上逾期的次数
            ,var0418 -- 过去6个月3期及以上逾期的次数
            ,var0419 -- 过去12个月3期及以上逾期的次数
            ,var0420 -- 过去3个月3期及以上逾期最后一次的距今月数
            ,var0421 -- 过去6个月3期及以上逾期最后一次的距今月数
            ,var0422 -- 过去12个月3期及以上逾期最后一次的距今月数
            ,var0423 -- 过去3个月4期及以上逾期的次数
            ,var0424 -- 过去6个月4期及以上逾期的次数
            ,var0425 -- 过去12个月4期及以上逾期的次数
            ,var0426 -- 过去3个月4期及以上逾期最后一次的距今月数
            ,var0427 -- 过去6个月4期及以上逾期最后一次的距今月数
            ,var0428 -- 过去12个月4期及以上逾期最后一次的距今月数
            ,var0429 -- 过去3个月内最长连续未逾期月数
            ,var0430 -- 过去6个月内最长连续未逾期月数
            ,var0431 -- 过去12个月内最长连续未逾期月数
            ,var0432 -- 过去3个月内最长连续逾期月数
            ,var0433 -- 过去6个月内最长连续逾期月数
            ,var0434 -- 过去12个月内最长连续逾期月数
            ,var0435 -- 过去3个月内逾期并且逾期期数连续增加的月数
            ,var0436 -- 过去6个月内逾期并且逾期期数连续增加的月数
            ,var0437 -- 过去12个月内逾期并且逾期期数连续增加的月数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_tzbl_yqqs_op(
            key_id -- 主键
            ,loan_no -- 借据号
            ,data_dt -- 数据日期
            ,loan_biz_type_cd -- 业务品种代码
            ,var0401 -- 当前月逾期期数
            ,var0402 -- 过去3个月逾期期数最大值
            ,var0403 -- 过去6个月逾期期数最大值
            ,var0404 -- 过去12个月逾期期数最大值
            ,var0405 -- 过去3个月1期及以上逾期的次数
            ,var0406 -- 过去6个月1期及以上逾期的次数
            ,var0407 -- 过去12个月1期及以上逾期的次数
            ,var0408 -- 过去3个月1期及以上逾期最后一次的距今月数
            ,var0409 -- 过去6个月1期及以上逾期最后一次的距今月数
            ,var0410 -- 过去12个月1期及以上逾期最后一次的距今月数
            ,var0411 -- 过去3个月2期及以上逾期的次数
            ,var0412 -- 过去6个月2期及以上逾期的次数
            ,var0413 -- 过去12个月2期及以上逾期的次数
            ,var0414 -- 过去3个月2期及以上逾期最后一次的距今月数
            ,var0415 -- 过去6个月2期及以上逾期最后一次的距今月数
            ,var0416 -- 过去12个月2期及以上逾期最后一次的距今月数
            ,var0417 -- 过去3个月3期及以上逾期的次数
            ,var0418 -- 过去6个月3期及以上逾期的次数
            ,var0419 -- 过去12个月3期及以上逾期的次数
            ,var0420 -- 过去3个月3期及以上逾期最后一次的距今月数
            ,var0421 -- 过去6个月3期及以上逾期最后一次的距今月数
            ,var0422 -- 过去12个月3期及以上逾期最后一次的距今月数
            ,var0423 -- 过去3个月4期及以上逾期的次数
            ,var0424 -- 过去6个月4期及以上逾期的次数
            ,var0425 -- 过去12个月4期及以上逾期的次数
            ,var0426 -- 过去3个月4期及以上逾期最后一次的距今月数
            ,var0427 -- 过去6个月4期及以上逾期最后一次的距今月数
            ,var0428 -- 过去12个月4期及以上逾期最后一次的距今月数
            ,var0429 -- 过去3个月内最长连续未逾期月数
            ,var0430 -- 过去6个月内最长连续未逾期月数
            ,var0431 -- 过去12个月内最长连续未逾期月数
            ,var0432 -- 过去3个月内最长连续逾期月数
            ,var0433 -- 过去6个月内最长连续逾期月数
            ,var0434 -- 过去12个月内最长连续逾期月数
            ,var0435 -- 过去3个月内逾期并且逾期期数连续增加的月数
            ,var0436 -- 过去6个月内逾期并且逾期期数连续增加的月数
            ,var0437 -- 过去12个月内逾期并且逾期期数连续增加的月数
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
    ,o.var0401 -- 当前月逾期期数
    ,o.var0402 -- 过去3个月逾期期数最大值
    ,o.var0403 -- 过去6个月逾期期数最大值
    ,o.var0404 -- 过去12个月逾期期数最大值
    ,o.var0405 -- 过去3个月1期及以上逾期的次数
    ,o.var0406 -- 过去6个月1期及以上逾期的次数
    ,o.var0407 -- 过去12个月1期及以上逾期的次数
    ,o.var0408 -- 过去3个月1期及以上逾期最后一次的距今月数
    ,o.var0409 -- 过去6个月1期及以上逾期最后一次的距今月数
    ,o.var0410 -- 过去12个月1期及以上逾期最后一次的距今月数
    ,o.var0411 -- 过去3个月2期及以上逾期的次数
    ,o.var0412 -- 过去6个月2期及以上逾期的次数
    ,o.var0413 -- 过去12个月2期及以上逾期的次数
    ,o.var0414 -- 过去3个月2期及以上逾期最后一次的距今月数
    ,o.var0415 -- 过去6个月2期及以上逾期最后一次的距今月数
    ,o.var0416 -- 过去12个月2期及以上逾期最后一次的距今月数
    ,o.var0417 -- 过去3个月3期及以上逾期的次数
    ,o.var0418 -- 过去6个月3期及以上逾期的次数
    ,o.var0419 -- 过去12个月3期及以上逾期的次数
    ,o.var0420 -- 过去3个月3期及以上逾期最后一次的距今月数
    ,o.var0421 -- 过去6个月3期及以上逾期最后一次的距今月数
    ,o.var0422 -- 过去12个月3期及以上逾期最后一次的距今月数
    ,o.var0423 -- 过去3个月4期及以上逾期的次数
    ,o.var0424 -- 过去6个月4期及以上逾期的次数
    ,o.var0425 -- 过去12个月4期及以上逾期的次数
    ,o.var0426 -- 过去3个月4期及以上逾期最后一次的距今月数
    ,o.var0427 -- 过去6个月4期及以上逾期最后一次的距今月数
    ,o.var0428 -- 过去12个月4期及以上逾期最后一次的距今月数
    ,o.var0429 -- 过去3个月内最长连续未逾期月数
    ,o.var0430 -- 过去6个月内最长连续未逾期月数
    ,o.var0431 -- 过去12个月内最长连续未逾期月数
    ,o.var0432 -- 过去3个月内最长连续逾期月数
    ,o.var0433 -- 过去6个月内最长连续逾期月数
    ,o.var0434 -- 过去12个月内最长连续逾期月数
    ,o.var0435 -- 过去3个月内逾期并且逾期期数连续增加的月数
    ,o.var0436 -- 过去6个月内逾期并且逾期期数连续增加的月数
    ,o.var0437 -- 过去12个月内逾期并且逾期期数连续增加的月数
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.rcds_ir_tzbl_yqqs_bk o
    left join ${iol_schema}.rcds_ir_tzbl_yqqs_op n
        on
            o.key_id = n.key_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rcds_ir_tzbl_yqqs_cl d
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
-- truncate table ${iol_schema}.rcds_ir_tzbl_yqqs;

-- 4.2 exchange partition
alter table ${iol_schema}.rcds_ir_tzbl_yqqs exchange partition p_19000101 with table ${iol_schema}.rcds_ir_tzbl_yqqs_cl;
alter table ${iol_schema}.rcds_ir_tzbl_yqqs exchange partition p_20991231 with table ${iol_schema}.rcds_ir_tzbl_yqqs_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rcds_ir_tzbl_yqqs to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_tzbl_yqqs_op purge;
drop table ${iol_schema}.rcds_ir_tzbl_yqqs_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rcds_ir_tzbl_yqqs_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rcds_ir_tzbl_yqqs',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
