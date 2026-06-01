/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wyd_tax_bank_data_query
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
create table ${iol_schema}.icms_wyd_tax_bank_data_query_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_wyd_tax_bank_data_query
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wyd_tax_bank_data_query_op purge;
drop table ${iol_schema}.icms_wyd_tax_bank_data_query_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wyd_tax_bank_data_query_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wyd_tax_bank_data_query where 0=1;

create table ${iol_schema}.icms_wyd_tax_bank_data_query_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wyd_tax_bank_data_query where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wyd_tax_bank_data_query_cl(
            serialno -- 流水号
            ,taxsno -- 税务数据查询流水
            ,taxpayerid -- 纳税人识别号
            ,enterprisename -- 企业名称
            ,tokenid -- 令牌
            ,biztype -- 业务类型
            ,taxqueryflag -- 税务查询标志(深圳/广东税务局)
            ,taxdatamajormsg -- 税务数据大报文
            ,taxdatacallrcrddtl -- 税务数据调用记录明细
            ,iscratefile -- 是否生成回盘文件
            ,isinform -- 是否已通知合作方
            ,filepath -- SFTP上的文件路径
            ,filename -- 文件名称
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,noncestr -- 请求微众流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wyd_tax_bank_data_query_op(
            serialno -- 流水号
            ,taxsno -- 税务数据查询流水
            ,taxpayerid -- 纳税人识别号
            ,enterprisename -- 企业名称
            ,tokenid -- 令牌
            ,biztype -- 业务类型
            ,taxqueryflag -- 税务查询标志(深圳/广东税务局)
            ,taxdatamajormsg -- 税务数据大报文
            ,taxdatacallrcrddtl -- 税务数据调用记录明细
            ,iscratefile -- 是否生成回盘文件
            ,isinform -- 是否已通知合作方
            ,filepath -- SFTP上的文件路径
            ,filename -- 文件名称
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,noncestr -- 请求微众流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.taxsno, o.taxsno) as taxsno -- 税务数据查询流水
    ,nvl(n.taxpayerid, o.taxpayerid) as taxpayerid -- 纳税人识别号
    ,nvl(n.enterprisename, o.enterprisename) as enterprisename -- 企业名称
    ,nvl(n.tokenid, o.tokenid) as tokenid -- 令牌
    ,nvl(n.biztype, o.biztype) as biztype -- 业务类型
    ,nvl(n.taxqueryflag, o.taxqueryflag) as taxqueryflag -- 税务查询标志(深圳/广东税务局)
    ,nvl(n.taxdatamajormsg, o.taxdatamajormsg) as taxdatamajormsg -- 税务数据大报文
    ,nvl(n.taxdatacallrcrddtl, o.taxdatacallrcrddtl) as taxdatacallrcrddtl -- 税务数据调用记录明细
    ,nvl(n.iscratefile, o.iscratefile) as iscratefile -- 是否生成回盘文件
    ,nvl(n.isinform, o.isinform) as isinform -- 是否已通知合作方
    ,nvl(n.filepath, o.filepath) as filepath -- SFTP上的文件路径
    ,nvl(n.filename, o.filename) as filename -- 文件名称
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.noncestr, o.noncestr) as noncestr -- 请求微众流水
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_wyd_tax_bank_data_query_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_wyd_tax_bank_data_query where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.taxsno <> n.taxsno
        or o.taxpayerid <> n.taxpayerid
        or o.enterprisename <> n.enterprisename
        or o.tokenid <> n.tokenid
        or o.biztype <> n.biztype
        or o.taxqueryflag <> n.taxqueryflag
        or o.taxdatamajormsg <> n.taxdatamajormsg
        or o.taxdatacallrcrddtl <> n.taxdatacallrcrddtl
        or o.iscratefile <> n.iscratefile
        or o.isinform <> n.isinform
        or o.filepath <> n.filepath
        or o.filename <> n.filename
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.noncestr <> n.noncestr
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wyd_tax_bank_data_query_cl(
            serialno -- 流水号
            ,taxsno -- 税务数据查询流水
            ,taxpayerid -- 纳税人识别号
            ,enterprisename -- 企业名称
            ,tokenid -- 令牌
            ,biztype -- 业务类型
            ,taxqueryflag -- 税务查询标志(深圳/广东税务局)
            ,taxdatamajormsg -- 税务数据大报文
            ,taxdatacallrcrddtl -- 税务数据调用记录明细
            ,iscratefile -- 是否生成回盘文件
            ,isinform -- 是否已通知合作方
            ,filepath -- SFTP上的文件路径
            ,filename -- 文件名称
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,noncestr -- 请求微众流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wyd_tax_bank_data_query_op(
            serialno -- 流水号
            ,taxsno -- 税务数据查询流水
            ,taxpayerid -- 纳税人识别号
            ,enterprisename -- 企业名称
            ,tokenid -- 令牌
            ,biztype -- 业务类型
            ,taxqueryflag -- 税务查询标志(深圳/广东税务局)
            ,taxdatamajormsg -- 税务数据大报文
            ,taxdatacallrcrddtl -- 税务数据调用记录明细
            ,iscratefile -- 是否生成回盘文件
            ,isinform -- 是否已通知合作方
            ,filepath -- SFTP上的文件路径
            ,filename -- 文件名称
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,noncestr -- 请求微众流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.taxsno -- 税务数据查询流水
    ,o.taxpayerid -- 纳税人识别号
    ,o.enterprisename -- 企业名称
    ,o.tokenid -- 令牌
    ,o.biztype -- 业务类型
    ,o.taxqueryflag -- 税务查询标志(深圳/广东税务局)
    ,o.taxdatamajormsg -- 税务数据大报文
    ,o.taxdatacallrcrddtl -- 税务数据调用记录明细
    ,o.iscratefile -- 是否生成回盘文件
    ,o.isinform -- 是否已通知合作方
    ,o.filepath -- SFTP上的文件路径
    ,o.filename -- 文件名称
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.noncestr -- 请求微众流水
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
from ${iol_schema}.icms_wyd_tax_bank_data_query_bk o
    left join ${iol_schema}.icms_wyd_tax_bank_data_query_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_wyd_tax_bank_data_query_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_wyd_tax_bank_data_query;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_wyd_tax_bank_data_query') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_wyd_tax_bank_data_query drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_wyd_tax_bank_data_query add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_wyd_tax_bank_data_query exchange partition p_${batch_date} with table ${iol_schema}.icms_wyd_tax_bank_data_query_cl;
alter table ${iol_schema}.icms_wyd_tax_bank_data_query exchange partition p_20991231 with table ${iol_schema}.icms_wyd_tax_bank_data_query_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wyd_tax_bank_data_query to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wyd_tax_bank_data_query_op purge;
drop table ${iol_schema}.icms_wyd_tax_bank_data_query_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_wyd_tax_bank_data_query_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wyd_tax_bank_data_query',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
