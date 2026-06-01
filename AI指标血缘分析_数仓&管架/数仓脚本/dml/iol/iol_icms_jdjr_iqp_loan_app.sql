/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_jdjr_iqp_loan_app
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.icms_jdjr_iqp_loan_app_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_jdjr_iqp_loan_app
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_jdjr_iqp_loan_app_op purge;
drop table ${iol_schema}.icms_jdjr_iqp_loan_app_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_jdjr_iqp_loan_app_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.icms_jdjr_iqp_loan_app where 0=1;

create table ${iol_schema}.icms_jdjr_iqp_loan_app_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.icms_jdjr_iqp_loan_app where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.icms_jdjr_iqp_loan_app_op(
        serno -- 流水号
        ,certtype -- 证件类型
        ,prdname -- 产品名称
        ,inputdate -- 录入日期
        ,approvestatus -- 审批状态
        ,autoscore -- 评分卡分值
        ,execrate -- 执行年利率，京东推送日利率X360
        ,floatratebp -- 利率浮动点差BP
        ,ratetype -- 利率类型1基准利率2LPR
        ,usertel -- 手机号
        ,interestrate -- 日利率
        ,ratefloatmode -- 利率浮动方式
        ,creditmode -- 授信模式
        ,address -- 通讯地址
        ,prdcode -- 产品代码
        ,inputbrid -- 登录机构
        ,lpr -- LPR
        ,applytime -- 申请时间
        ,businesstype -- 业务场景
        ,inputid -- 登记人
        ,failreason -- 拒绝原因
        ,applyno -- 申请号
        ,cusid -- 客户号
        ,enddate -- 审批结束时间
        ,prdno -- 产品编号（借据用）
        ,pin -- 用户标识
        ,certno -- 身份证号
        ,username -- 客户姓名
        ,startdate -- 审批开始时间
        ,migtflag -- 迁移标志：crsrcrilcupl
        ,applyamount -- 申请额度（元）
        ,activatetag -- 激活标签
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.serno -- 流水号
    ,n.certtype -- 证件类型
    ,n.prdname -- 产品名称
    ,n.inputdate -- 录入日期
    ,n.approvestatus -- 审批状态
    ,n.autoscore -- 评分卡分值
    ,n.execrate -- 执行年利率，京东推送日利率X360
    ,n.floatratebp -- 利率浮动点差BP
    ,n.ratetype -- 利率类型1基准利率2LPR
    ,n.usertel -- 手机号
    ,n.interestrate -- 日利率
    ,n.ratefloatmode -- 利率浮动方式
    ,n.creditmode -- 授信模式
    ,n.address -- 通讯地址
    ,n.prdcode -- 产品代码
    ,n.inputbrid -- 登录机构
    ,n.lpr -- LPR
    ,n.applytime -- 申请时间
    ,n.businesstype -- 业务场景
    ,n.inputid -- 登记人
    ,n.failreason -- 拒绝原因
    ,n.applyno -- 申请号
    ,n.cusid -- 客户号
    ,n.enddate -- 审批结束时间
    ,n.prdno -- 产品编号（借据用）
    ,n.pin -- 用户标识
    ,n.certno -- 身份证号
    ,n.username -- 客户姓名
    ,n.startdate -- 审批开始时间
    ,n.migtflag -- 迁移标志：crsrcrilcupl
    ,n.applyamount -- 申请额度（元）
    ,n.activatetag -- 激活标签
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_jdjr_iqp_loan_app_bk o
    right join (select * from ${itl_schema}.icms_jdjr_iqp_loan_app where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serno = n.serno
where (
        o.serno is null
    )
    or (
        o.certtype <> n.certtype
        or o.prdname <> n.prdname
        or o.inputdate <> n.inputdate
        or o.approvestatus <> n.approvestatus
        or o.autoscore <> n.autoscore
        or o.execrate <> n.execrate
        or o.floatratebp <> n.floatratebp
        or o.ratetype <> n.ratetype
        or o.usertel <> n.usertel
        or o.interestrate <> n.interestrate
        or o.ratefloatmode <> n.ratefloatmode
        or o.creditmode <> n.creditmode
        or o.address <> n.address
        or o.prdcode <> n.prdcode
        or o.inputbrid <> n.inputbrid
        or o.lpr <> n.lpr
        or o.applytime <> n.applytime
        or o.businesstype <> n.businesstype
        or o.inputid <> n.inputid
        or o.failreason <> n.failreason
        or o.applyno <> n.applyno
        or o.cusid <> n.cusid
        or o.enddate <> n.enddate
        or o.prdno <> n.prdno
        or o.pin <> n.pin
        or o.certno <> n.certno
        or o.username <> n.username
        or o.startdate <> n.startdate
        or o.migtflag <> n.migtflag
        or o.applyamount <> n.applyamount
        or o.activatetag <> n.activatetag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_jdjr_iqp_loan_app_cl(
            serno -- 流水号
        ,certtype -- 证件类型
        ,prdname -- 产品名称
        ,inputdate -- 录入日期
        ,approvestatus -- 审批状态
        ,autoscore -- 评分卡分值
        ,execrate -- 执行年利率，京东推送日利率X360
        ,floatratebp -- 利率浮动点差BP
        ,ratetype -- 利率类型1基准利率2LPR
        ,usertel -- 手机号
        ,interestrate -- 日利率
        ,ratefloatmode -- 利率浮动方式
        ,creditmode -- 授信模式
        ,address -- 通讯地址
        ,prdcode -- 产品代码
        ,inputbrid -- 登录机构
        ,lpr -- LPR
        ,applytime -- 申请时间
        ,businesstype -- 业务场景
        ,inputid -- 登记人
        ,failreason -- 拒绝原因
        ,applyno -- 申请号
        ,cusid -- 客户号
        ,enddate -- 审批结束时间
        ,prdno -- 产品编号（借据用）
        ,pin -- 用户标识
        ,certno -- 身份证号
        ,username -- 客户姓名
        ,startdate -- 审批开始时间
        ,migtflag -- 迁移标志：crsrcrilcupl
        ,applyamount -- 申请额度（元）
        ,activatetag -- 激活标签
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_jdjr_iqp_loan_app_op(
            serno -- 流水号
        ,certtype -- 证件类型
        ,prdname -- 产品名称
        ,inputdate -- 录入日期
        ,approvestatus -- 审批状态
        ,autoscore -- 评分卡分值
        ,execrate -- 执行年利率，京东推送日利率X360
        ,floatratebp -- 利率浮动点差BP
        ,ratetype -- 利率类型1基准利率2LPR
        ,usertel -- 手机号
        ,interestrate -- 日利率
        ,ratefloatmode -- 利率浮动方式
        ,creditmode -- 授信模式
        ,address -- 通讯地址
        ,prdcode -- 产品代码
        ,inputbrid -- 登录机构
        ,lpr -- LPR
        ,applytime -- 申请时间
        ,businesstype -- 业务场景
        ,inputid -- 登记人
        ,failreason -- 拒绝原因
        ,applyno -- 申请号
        ,cusid -- 客户号
        ,enddate -- 审批结束时间
        ,prdno -- 产品编号（借据用）
        ,pin -- 用户标识
        ,certno -- 身份证号
        ,username -- 客户姓名
        ,startdate -- 审批开始时间
        ,migtflag -- 迁移标志：crsrcrilcupl
        ,applyamount -- 申请额度（元）
        ,activatetag -- 激活标签
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serno -- 流水号
    ,o.certtype -- 证件类型
    ,o.prdname -- 产品名称
    ,o.inputdate -- 录入日期
    ,o.approvestatus -- 审批状态
    ,o.autoscore -- 评分卡分值
    ,o.execrate -- 执行年利率，京东推送日利率X360
    ,o.floatratebp -- 利率浮动点差BP
    ,o.ratetype -- 利率类型1基准利率2LPR
    ,o.usertel -- 手机号
    ,o.interestrate -- 日利率
    ,o.ratefloatmode -- 利率浮动方式
    ,o.creditmode -- 授信模式
    ,o.address -- 通讯地址
    ,o.prdcode -- 产品代码
    ,o.inputbrid -- 登录机构
    ,o.lpr -- LPR
    ,o.applytime -- 申请时间
    ,o.businesstype -- 业务场景
    ,o.inputid -- 登记人
    ,o.failreason -- 拒绝原因
    ,o.applyno -- 申请号
    ,o.cusid -- 客户号
    ,o.enddate -- 审批结束时间
    ,o.prdno -- 产品编号（借据用）
    ,o.pin -- 用户标识
    ,o.certno -- 身份证号
    ,o.username -- 客户姓名
    ,o.startdate -- 审批开始时间
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.applyamount -- 申请额度（元）
    ,o.activatetag -- 激活标签
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_jdjr_iqp_loan_app_bk o
    left join ${iol_schema}.icms_jdjr_iqp_loan_app_op n
        on
            o.serno = n.serno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_jdjr_iqp_loan_app;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_jdjr_iqp_loan_app') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_jdjr_iqp_loan_app drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_jdjr_iqp_loan_app add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_jdjr_iqp_loan_app exchange partition p_${batch_date} with table ${iol_schema}.icms_jdjr_iqp_loan_app_cl;
alter table ${iol_schema}.icms_jdjr_iqp_loan_app exchange partition p_20991231 with table ${iol_schema}.icms_jdjr_iqp_loan_app_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_jdjr_iqp_loan_app to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_jdjr_iqp_loan_app_op purge;
drop table ${iol_schema}.icms_jdjr_iqp_loan_app_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_jdjr_iqp_loan_app_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_jdjr_iqp_loan_app',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
