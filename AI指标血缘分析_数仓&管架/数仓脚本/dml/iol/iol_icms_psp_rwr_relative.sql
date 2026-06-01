/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_psp_rwr_relative
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
create table ${iol_schema}.icms_psp_rwr_relative_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_psp_rwr_relative
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_psp_rwr_relative_op purge;
drop table ${iol_schema}.icms_psp_rwr_relative_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_psp_rwr_relative_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_psp_rwr_relative where 0=1;

create table ${iol_schema}.icms_psp_rwr_relative_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_psp_rwr_relative where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_psp_rwr_relative_cl(
            warningruleno -- 预警规则编号
            ,warningsignalno -- 预警信号编号
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,warningcode -- 预警规则代码
            ,warningsign -- 预警信号规则名称
            ,warningrule -- 预警规则（内容）
            ,signlevel -- 预警信号级别
            ,migtflag -- 迁移标识
            ,duebillserialno -- 借据编号
            ,kgsurl -- 知识图谱链接
            ,tokenid -- 进件tokenId
            ,finaldecisionname -- 最终决策结果名称
            ,rulesets -- 规则集详情
            ,rulesetscode -- 规则集编码
            ,phonereason -- 手机号码入库原因
            ,creatreason -- 证件号码入库原因
            ,companyreason -- 企业名称入库原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_psp_rwr_relative_op(
            warningruleno -- 预警规则编号
            ,warningsignalno -- 预警信号编号
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,warningcode -- 预警规则代码
            ,warningsign -- 预警信号规则名称
            ,warningrule -- 预警规则（内容）
            ,signlevel -- 预警信号级别
            ,migtflag -- 迁移标识
            ,duebillserialno -- 借据编号
            ,kgsurl -- 知识图谱链接
            ,tokenid -- 进件tokenId
            ,finaldecisionname -- 最终决策结果名称
            ,rulesets -- 规则集详情
            ,rulesetscode -- 规则集编码
            ,phonereason -- 手机号码入库原因
            ,creatreason -- 证件号码入库原因
            ,companyreason -- 企业名称入库原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.warningruleno, o.warningruleno) as warningruleno -- 预警规则编号
    ,nvl(n.warningsignalno, o.warningsignalno) as warningsignalno -- 预警信号编号
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.warningcode, o.warningcode) as warningcode -- 预警规则代码
    ,nvl(n.warningsign, o.warningsign) as warningsign -- 预警信号规则名称
    ,nvl(n.warningrule, o.warningrule) as warningrule -- 预警规则（内容）
    ,nvl(n.signlevel, o.signlevel) as signlevel -- 预警信号级别
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标识
    ,nvl(n.duebillserialno, o.duebillserialno) as duebillserialno -- 借据编号
    ,nvl(n.kgsurl, o.kgsurl) as kgsurl -- 知识图谱链接
    ,nvl(n.tokenid, o.tokenid) as tokenid -- 进件tokenId
    ,nvl(n.finaldecisionname, o.finaldecisionname) as finaldecisionname -- 最终决策结果名称
    ,nvl(n.rulesets, o.rulesets) as rulesets -- 规则集详情
    ,nvl(n.rulesetscode, o.rulesetscode) as rulesetscode -- 规则集编码
    ,nvl(n.phonereason, o.phonereason) as phonereason -- 手机号码入库原因
    ,nvl(n.creatreason, o.creatreason) as creatreason -- 证件号码入库原因
    ,nvl(n.companyreason, o.companyreason) as companyreason -- 企业名称入库原因
    ,case when
            n.warningruleno is null
            and n.warningsignalno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.warningruleno is null
            and n.warningsignalno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.warningruleno is null
            and n.warningsignalno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_psp_rwr_relative_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_psp_rwr_relative where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.warningruleno = n.warningruleno
            and o.warningsignalno = n.warningsignalno
where (
        o.warningruleno is null
        and o.warningsignalno is null
    )
    or (
        n.warningruleno is null
        and n.warningsignalno is null
    )
    or (
        o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updatedate <> n.updatedate
        or o.updateorgid <> n.updateorgid
        or o.updateuserid <> n.updateuserid
        or o.warningcode <> n.warningcode
        or o.warningsign <> n.warningsign
        or o.warningrule <> n.warningrule
        or o.signlevel <> n.signlevel
        or o.migtflag <> n.migtflag
        or o.duebillserialno <> n.duebillserialno
        or o.kgsurl <> n.kgsurl
        or o.tokenid <> n.tokenid
        or o.finaldecisionname <> n.finaldecisionname
        or o.rulesets <> n.rulesets
        or o.rulesetscode <> n.rulesetscode
        or o.phonereason <> n.phonereason
        or o.creatreason <> n.creatreason
        or o.companyreason <> n.companyreason
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_psp_rwr_relative_cl(
            warningruleno -- 预警规则编号
            ,warningsignalno -- 预警信号编号
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,warningcode -- 预警规则代码
            ,warningsign -- 预警信号规则名称
            ,warningrule -- 预警规则（内容）
            ,signlevel -- 预警信号级别
            ,migtflag -- 迁移标识
            ,duebillserialno -- 借据编号
            ,kgsurl -- 知识图谱链接
            ,tokenid -- 进件tokenId
            ,finaldecisionname -- 最终决策结果名称
            ,rulesets -- 规则集详情
            ,rulesetscode -- 规则集编码
            ,phonereason -- 手机号码入库原因
            ,creatreason -- 证件号码入库原因
            ,companyreason -- 企业名称入库原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_psp_rwr_relative_op(
            warningruleno -- 预警规则编号
            ,warningsignalno -- 预警信号编号
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,warningcode -- 预警规则代码
            ,warningsign -- 预警信号规则名称
            ,warningrule -- 预警规则（内容）
            ,signlevel -- 预警信号级别
            ,migtflag -- 迁移标识
            ,duebillserialno -- 借据编号
            ,kgsurl -- 知识图谱链接
            ,tokenid -- 进件tokenId
            ,finaldecisionname -- 最终决策结果名称
            ,rulesets -- 规则集详情
            ,rulesetscode -- 规则集编码
            ,phonereason -- 手机号码入库原因
            ,creatreason -- 证件号码入库原因
            ,companyreason -- 企业名称入库原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.warningruleno -- 预警规则编号
    ,o.warningsignalno -- 预警信号编号
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updatedate -- 更新日期
    ,o.updateorgid -- 更新机构
    ,o.updateuserid -- 更新人
    ,o.warningcode -- 预警规则代码
    ,o.warningsign -- 预警信号规则名称
    ,o.warningrule -- 预警规则（内容）
    ,o.signlevel -- 预警信号级别
    ,o.migtflag -- 迁移标识
    ,o.duebillserialno -- 借据编号
    ,o.kgsurl -- 知识图谱链接
    ,o.tokenid -- 进件tokenId
    ,o.finaldecisionname -- 最终决策结果名称
    ,o.rulesets -- 规则集详情
    ,o.rulesetscode -- 规则集编码
    ,o.phonereason -- 手机号码入库原因
    ,o.creatreason -- 证件号码入库原因
    ,o.companyreason -- 企业名称入库原因
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
from ${iol_schema}.icms_psp_rwr_relative_bk o
    left join ${iol_schema}.icms_psp_rwr_relative_op n
        on
            o.warningruleno = n.warningruleno
            and o.warningsignalno = n.warningsignalno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_psp_rwr_relative_cl d
        on
            o.warningruleno = d.warningruleno
            and o.warningsignalno = d.warningsignalno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_psp_rwr_relative;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_psp_rwr_relative') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_psp_rwr_relative drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_psp_rwr_relative add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_psp_rwr_relative exchange partition p_${batch_date} with table ${iol_schema}.icms_psp_rwr_relative_cl;
alter table ${iol_schema}.icms_psp_rwr_relative exchange partition p_20991231 with table ${iol_schema}.icms_psp_rwr_relative_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_psp_rwr_relative to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_psp_rwr_relative_op purge;
drop table ${iol_schema}.icms_psp_rwr_relative_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_psp_rwr_relative_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_psp_rwr_relative',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
