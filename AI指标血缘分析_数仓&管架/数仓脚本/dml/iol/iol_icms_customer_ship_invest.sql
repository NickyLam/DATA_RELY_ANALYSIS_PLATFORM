/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_customer_ship_invest
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
create table ${iol_schema}.icms_customer_ship_invest_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_customer_ship_invest
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_ship_invest_op purge;
drop table ${iol_schema}.icms_customer_ship_invest_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_ship_invest_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_ship_invest where 0=1;

create table ${iol_schema}.icms_customer_ship_invest_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_ship_invest where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_ship_invest_cl(
            serialno -- 流水号
            ,certid -- 投向企业证件号码
            ,remark -- 备注
            ,indname -- 投向企业法人代表名称
            ,updatedate -- 更新日期
            ,customername -- 投向企业姓名
            ,certtype -- 投向企业证件类型
            ,oughtsum -- 出资金额
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,inputuserid -- 登记人
            ,updateuserid -- 更新人
            ,loancardno -- 投向企业贷款卡编号
            ,maincustomerid -- 主客户号
            ,investmentprop -- 出资比例
            ,inputorgid -- 登记机构
            ,corporgid -- 法人机构编号
            ,customerid -- 客户编号
            ,enttype -- 企业类型
            ,relationship -- 投资方式
            ,updateorgid -- 更新机构
            ,firstearnings -- 第一年投资收益
            ,creditinstitutioncode -- 机构信用代码
            ,customertype -- 投向企业类型
            ,relationstate -- 投资情况
            ,investdate -- 投资日期
            ,relatetype -- 关联类型
            ,tempstatus -- 暂存状态
            ,currency -- 出资币种
            ,investmentsum -- 实际投资金额
            ,inputdate -- 登记日期
            ,migtoldvalue -- 备份原字段值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_ship_invest_op(
            serialno -- 流水号
            ,certid -- 投向企业证件号码
            ,remark -- 备注
            ,indname -- 投向企业法人代表名称
            ,updatedate -- 更新日期
            ,customername -- 投向企业姓名
            ,certtype -- 投向企业证件类型
            ,oughtsum -- 出资金额
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,inputuserid -- 登记人
            ,updateuserid -- 更新人
            ,loancardno -- 投向企业贷款卡编号
            ,maincustomerid -- 主客户号
            ,investmentprop -- 出资比例
            ,inputorgid -- 登记机构
            ,corporgid -- 法人机构编号
            ,customerid -- 客户编号
            ,enttype -- 企业类型
            ,relationship -- 投资方式
            ,updateorgid -- 更新机构
            ,firstearnings -- 第一年投资收益
            ,creditinstitutioncode -- 机构信用代码
            ,customertype -- 投向企业类型
            ,relationstate -- 投资情况
            ,investdate -- 投资日期
            ,relatetype -- 关联类型
            ,tempstatus -- 暂存状态
            ,currency -- 出资币种
            ,investmentsum -- 实际投资金额
            ,inputdate -- 登记日期
            ,migtoldvalue -- 备份原字段值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.certid, o.certid) as certid -- 投向企业证件号码
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.indname, o.indname) as indname -- 投向企业法人代表名称
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.customername, o.customername) as customername -- 投向企业姓名
    ,nvl(n.certtype, o.certtype) as certtype -- 投向企业证件类型
    ,nvl(n.oughtsum, o.oughtsum) as oughtsum -- 出资金额
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.loancardno, o.loancardno) as loancardno -- 投向企业贷款卡编号
    ,nvl(n.maincustomerid, o.maincustomerid) as maincustomerid -- 主客户号
    ,nvl(n.investmentprop, o.investmentprop) as investmentprop -- 出资比例
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.enttype, o.enttype) as enttype -- 企业类型
    ,nvl(n.relationship, o.relationship) as relationship -- 投资方式
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.firstearnings, o.firstearnings) as firstearnings -- 第一年投资收益
    ,nvl(n.creditinstitutioncode, o.creditinstitutioncode) as creditinstitutioncode -- 机构信用代码
    ,nvl(n.customertype, o.customertype) as customertype -- 投向企业类型
    ,nvl(n.relationstate, o.relationstate) as relationstate -- 投资情况
    ,nvl(n.investdate, o.investdate) as investdate -- 投资日期
    ,nvl(n.relatetype, o.relatetype) as relatetype -- 关联类型
    ,nvl(n.tempstatus, o.tempstatus) as tempstatus -- 暂存状态
    ,nvl(n.currency, o.currency) as currency -- 出资币种
    ,nvl(n.investmentsum, o.investmentsum) as investmentsum -- 实际投资金额
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.migtoldvalue, o.migtoldvalue) as migtoldvalue -- 备份原字段值
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
from (select * from ${iol_schema}.icms_customer_ship_invest_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_customer_ship_invest where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.certid <> n.certid
        or o.remark <> n.remark
        or o.indname <> n.indname
        or o.updatedate <> n.updatedate
        or o.customername <> n.customername
        or o.certtype <> n.certtype
        or o.oughtsum <> n.oughtsum
        or o.migtflag <> n.migtflag
        or o.inputuserid <> n.inputuserid
        or o.updateuserid <> n.updateuserid
        or o.loancardno <> n.loancardno
        or o.maincustomerid <> n.maincustomerid
        or o.investmentprop <> n.investmentprop
        or o.inputorgid <> n.inputorgid
        or o.corporgid <> n.corporgid
        or o.customerid <> n.customerid
        or o.enttype <> n.enttype
        or o.relationship <> n.relationship
        or o.updateorgid <> n.updateorgid
        or o.firstearnings <> n.firstearnings
        or o.creditinstitutioncode <> n.creditinstitutioncode
        or o.customertype <> n.customertype
        or o.relationstate <> n.relationstate
        or o.investdate <> n.investdate
        or o.relatetype <> n.relatetype
        or o.tempstatus <> n.tempstatus
        or o.currency <> n.currency
        or o.investmentsum <> n.investmentsum
        or o.inputdate <> n.inputdate
        or o.migtoldvalue <> n.migtoldvalue
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_ship_invest_cl(
            serialno -- 流水号
            ,certid -- 投向企业证件号码
            ,remark -- 备注
            ,indname -- 投向企业法人代表名称
            ,updatedate -- 更新日期
            ,customername -- 投向企业姓名
            ,certtype -- 投向企业证件类型
            ,oughtsum -- 出资金额
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,inputuserid -- 登记人
            ,updateuserid -- 更新人
            ,loancardno -- 投向企业贷款卡编号
            ,maincustomerid -- 主客户号
            ,investmentprop -- 出资比例
            ,inputorgid -- 登记机构
            ,corporgid -- 法人机构编号
            ,customerid -- 客户编号
            ,enttype -- 企业类型
            ,relationship -- 投资方式
            ,updateorgid -- 更新机构
            ,firstearnings -- 第一年投资收益
            ,creditinstitutioncode -- 机构信用代码
            ,customertype -- 投向企业类型
            ,relationstate -- 投资情况
            ,investdate -- 投资日期
            ,relatetype -- 关联类型
            ,tempstatus -- 暂存状态
            ,currency -- 出资币种
            ,investmentsum -- 实际投资金额
            ,inputdate -- 登记日期
            ,migtoldvalue -- 备份原字段值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_ship_invest_op(
            serialno -- 流水号
            ,certid -- 投向企业证件号码
            ,remark -- 备注
            ,indname -- 投向企业法人代表名称
            ,updatedate -- 更新日期
            ,customername -- 投向企业姓名
            ,certtype -- 投向企业证件类型
            ,oughtsum -- 出资金额
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,inputuserid -- 登记人
            ,updateuserid -- 更新人
            ,loancardno -- 投向企业贷款卡编号
            ,maincustomerid -- 主客户号
            ,investmentprop -- 出资比例
            ,inputorgid -- 登记机构
            ,corporgid -- 法人机构编号
            ,customerid -- 客户编号
            ,enttype -- 企业类型
            ,relationship -- 投资方式
            ,updateorgid -- 更新机构
            ,firstearnings -- 第一年投资收益
            ,creditinstitutioncode -- 机构信用代码
            ,customertype -- 投向企业类型
            ,relationstate -- 投资情况
            ,investdate -- 投资日期
            ,relatetype -- 关联类型
            ,tempstatus -- 暂存状态
            ,currency -- 出资币种
            ,investmentsum -- 实际投资金额
            ,inputdate -- 登记日期
            ,migtoldvalue -- 备份原字段值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.certid -- 投向企业证件号码
    ,o.remark -- 备注
    ,o.indname -- 投向企业法人代表名称
    ,o.updatedate -- 更新日期
    ,o.customername -- 投向企业姓名
    ,o.certtype -- 投向企业证件类型
    ,o.oughtsum -- 出资金额
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.inputuserid -- 登记人
    ,o.updateuserid -- 更新人
    ,o.loancardno -- 投向企业贷款卡编号
    ,o.maincustomerid -- 主客户号
    ,o.investmentprop -- 出资比例
    ,o.inputorgid -- 登记机构
    ,o.corporgid -- 法人机构编号
    ,o.customerid -- 客户编号
    ,o.enttype -- 企业类型
    ,o.relationship -- 投资方式
    ,o.updateorgid -- 更新机构
    ,o.firstearnings -- 第一年投资收益
    ,o.creditinstitutioncode -- 机构信用代码
    ,o.customertype -- 投向企业类型
    ,o.relationstate -- 投资情况
    ,o.investdate -- 投资日期
    ,o.relatetype -- 关联类型
    ,o.tempstatus -- 暂存状态
    ,o.currency -- 出资币种
    ,o.investmentsum -- 实际投资金额
    ,o.inputdate -- 登记日期
    ,o.migtoldvalue -- 备份原字段值
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
from ${iol_schema}.icms_customer_ship_invest_bk o
    left join ${iol_schema}.icms_customer_ship_invest_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_customer_ship_invest_cl d
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
--truncate table ${iol_schema}.icms_customer_ship_invest;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_customer_ship_invest') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_customer_ship_invest drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_customer_ship_invest add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_customer_ship_invest exchange partition p_${batch_date} with table ${iol_schema}.icms_customer_ship_invest_cl;
alter table ${iol_schema}.icms_customer_ship_invest exchange partition p_20991231 with table ${iol_schema}.icms_customer_ship_invest_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_customer_ship_invest to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_ship_invest_op purge;
drop table ${iol_schema}.icms_customer_ship_invest_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_customer_ship_invest_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_customer_ship_invest',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
