/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_proce_apply
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
create table ${iol_schema}.icms_ap_proce_apply_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_proce_apply
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_proce_apply_op purge;
drop table ${iol_schema}.icms_ap_proce_apply_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_proce_apply_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_proce_apply where 0=1;

create table ${iol_schema}.icms_ap_proce_apply_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_proce_apply where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_proce_apply_cl(
            applyno -- 破产权利申报编号
            ,declareamt -- 申报金额
            ,declaredate -- 申报日期
            ,firmamt -- 认定金额
            ,saveflag -- 保存状态
            ,remark -- 备注
            ,updateuserid -- 更新人编号
            ,caseno -- 关联案件项目编号
            ,firmdate -- 认定日期
            ,description -- 文字描述
            ,ispledge -- 是否有抵质押
            ,inputuserid -- 登记人编号
            ,bankappearratio -- 我行债权比例
            ,tmsp -- 时间戳
            ,inputorgid -- 登记机构编号
            ,inputdate -- 登记日期
            ,pledgeamt -- 抵质押金额
            ,appearratio -- 债权比例
            ,updateorgid -- 更新机构编号
            ,appearid -- 债权申报人编号
            ,updatedate -- 更新日期
            ,appearname -- 债权申报人
            ,caseprogramstage -- 程序阶段信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_proce_apply_op(
            applyno -- 破产权利申报编号
            ,declareamt -- 申报金额
            ,declaredate -- 申报日期
            ,firmamt -- 认定金额
            ,saveflag -- 保存状态
            ,remark -- 备注
            ,updateuserid -- 更新人编号
            ,caseno -- 关联案件项目编号
            ,firmdate -- 认定日期
            ,description -- 文字描述
            ,ispledge -- 是否有抵质押
            ,inputuserid -- 登记人编号
            ,bankappearratio -- 我行债权比例
            ,tmsp -- 时间戳
            ,inputorgid -- 登记机构编号
            ,inputdate -- 登记日期
            ,pledgeamt -- 抵质押金额
            ,appearratio -- 债权比例
            ,updateorgid -- 更新机构编号
            ,appearid -- 债权申报人编号
            ,updatedate -- 更新日期
            ,appearname -- 债权申报人
            ,caseprogramstage -- 程序阶段信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.applyno, o.applyno) as applyno -- 破产权利申报编号
    ,nvl(n.declareamt, o.declareamt) as declareamt -- 申报金额
    ,nvl(n.declaredate, o.declaredate) as declaredate -- 申报日期
    ,nvl(n.firmamt, o.firmamt) as firmamt -- 认定金额
    ,nvl(n.saveflag, o.saveflag) as saveflag -- 保存状态
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人编号
    ,nvl(n.caseno, o.caseno) as caseno -- 关联案件项目编号
    ,nvl(n.firmdate, o.firmdate) as firmdate -- 认定日期
    ,nvl(n.description, o.description) as description -- 文字描述
    ,nvl(n.ispledge, o.ispledge) as ispledge -- 是否有抵质押
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人编号
    ,nvl(n.bankappearratio, o.bankappearratio) as bankappearratio -- 我行债权比例
    ,nvl(n.tmsp, o.tmsp) as tmsp -- 时间戳
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构编号
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.pledgeamt, o.pledgeamt) as pledgeamt -- 抵质押金额
    ,nvl(n.appearratio, o.appearratio) as appearratio -- 债权比例
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构编号
    ,nvl(n.appearid, o.appearid) as appearid -- 债权申报人编号
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.appearname, o.appearname) as appearname -- 债权申报人
    ,nvl(n.caseprogramstage, o.caseprogramstage) as caseprogramstage -- 程序阶段信息
    ,case when
            n.applyno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.applyno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.applyno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_proce_apply_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_proce_apply where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.applyno = n.applyno
where (
        o.applyno is null
    )
    or (
        n.applyno is null
    )
    or (
        o.declareamt <> n.declareamt
        or o.declaredate <> n.declaredate
        or o.firmamt <> n.firmamt
        or o.saveflag <> n.saveflag
        or o.remark <> n.remark
        or o.updateuserid <> n.updateuserid
        or o.caseno <> n.caseno
        or o.firmdate <> n.firmdate
        or o.description <> n.description
        or o.ispledge <> n.ispledge
        or o.inputuserid <> n.inputuserid
        or o.bankappearratio <> n.bankappearratio
        or o.tmsp <> n.tmsp
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.pledgeamt <> n.pledgeamt
        or o.appearratio <> n.appearratio
        or o.updateorgid <> n.updateorgid
        or o.appearid <> n.appearid
        or o.updatedate <> n.updatedate
        or o.appearname <> n.appearname
        or o.caseprogramstage <> n.caseprogramstage
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_proce_apply_cl(
            applyno -- 破产权利申报编号
            ,declareamt -- 申报金额
            ,declaredate -- 申报日期
            ,firmamt -- 认定金额
            ,saveflag -- 保存状态
            ,remark -- 备注
            ,updateuserid -- 更新人编号
            ,caseno -- 关联案件项目编号
            ,firmdate -- 认定日期
            ,description -- 文字描述
            ,ispledge -- 是否有抵质押
            ,inputuserid -- 登记人编号
            ,bankappearratio -- 我行债权比例
            ,tmsp -- 时间戳
            ,inputorgid -- 登记机构编号
            ,inputdate -- 登记日期
            ,pledgeamt -- 抵质押金额
            ,appearratio -- 债权比例
            ,updateorgid -- 更新机构编号
            ,appearid -- 债权申报人编号
            ,updatedate -- 更新日期
            ,appearname -- 债权申报人
            ,caseprogramstage -- 程序阶段信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_proce_apply_op(
            applyno -- 破产权利申报编号
            ,declareamt -- 申报金额
            ,declaredate -- 申报日期
            ,firmamt -- 认定金额
            ,saveflag -- 保存状态
            ,remark -- 备注
            ,updateuserid -- 更新人编号
            ,caseno -- 关联案件项目编号
            ,firmdate -- 认定日期
            ,description -- 文字描述
            ,ispledge -- 是否有抵质押
            ,inputuserid -- 登记人编号
            ,bankappearratio -- 我行债权比例
            ,tmsp -- 时间戳
            ,inputorgid -- 登记机构编号
            ,inputdate -- 登记日期
            ,pledgeamt -- 抵质押金额
            ,appearratio -- 债权比例
            ,updateorgid -- 更新机构编号
            ,appearid -- 债权申报人编号
            ,updatedate -- 更新日期
            ,appearname -- 债权申报人
            ,caseprogramstage -- 程序阶段信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.applyno -- 破产权利申报编号
    ,o.declareamt -- 申报金额
    ,o.declaredate -- 申报日期
    ,o.firmamt -- 认定金额
    ,o.saveflag -- 保存状态
    ,o.remark -- 备注
    ,o.updateuserid -- 更新人编号
    ,o.caseno -- 关联案件项目编号
    ,o.firmdate -- 认定日期
    ,o.description -- 文字描述
    ,o.ispledge -- 是否有抵质押
    ,o.inputuserid -- 登记人编号
    ,o.bankappearratio -- 我行债权比例
    ,o.tmsp -- 时间戳
    ,o.inputorgid -- 登记机构编号
    ,o.inputdate -- 登记日期
    ,o.pledgeamt -- 抵质押金额
    ,o.appearratio -- 债权比例
    ,o.updateorgid -- 更新机构编号
    ,o.appearid -- 债权申报人编号
    ,o.updatedate -- 更新日期
    ,o.appearname -- 债权申报人
    ,o.caseprogramstage -- 程序阶段信息
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_ap_proce_apply_bk o
    left join ${iol_schema}.icms_ap_proce_apply_op n
        on
            o.applyno = n.applyno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_proce_apply_cl d
        on
            o.applyno = d.applyno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_proce_apply;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_proce_apply') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_proce_apply drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_proce_apply add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_proce_apply exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_proce_apply_cl;
alter table ${iol_schema}.icms_ap_proce_apply exchange partition p_20991231 with table ${iol_schema}.icms_ap_proce_apply_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_proce_apply to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_proce_apply_op purge;
drop table ${iol_schema}.icms_ap_proce_apply_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_proce_apply_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_proce_apply',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
