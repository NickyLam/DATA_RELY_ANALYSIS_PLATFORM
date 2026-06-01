/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_guaranty_info
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
create table ${iol_schema}.icms_ap_guaranty_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_guaranty_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_guaranty_info_op purge;
drop table ${iol_schema}.icms_ap_guaranty_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_guaranty_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_guaranty_info where 0=1;

create table ${iol_schema}.icms_ap_guaranty_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_guaranty_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_guaranty_info_cl(
            guarantyid -- 抵债资产编号
            ,guarantytype -- 抵债物类型
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,evalorgid -- 评估公司ID
            ,guarantymanager -- 抵债资产管理人
            ,guarantyownerid -- 抵债资产所有人ID
            ,firstevalorgid -- 授信时评估公司ID
            ,debtassetstatus -- 抵债资产状态
            ,evalorgname -- 评估公司名称
            ,firstevalcurrency -- 授信时评估币种
            ,evaldate -- 评估日期
            ,evalcurrency -- 评估币种
            ,tmsp -- 时间戳
            ,deleteflag -- 删除标志
            ,guapreparesum -- 抵债资产的减值准备
            ,guaacctsum -- 抵债资产入账价值
            ,firstevalorgname -- 授信时评估公司名称
            ,updateorgid -- 更新机构
            ,guarantyname -- 抵债资产名称
            ,guarantylist -- 押品细类
            ,guarantylocation -- 抵债资产存放地点
            ,guarantymanagerid -- 抵债资产管理人ID
            ,transferflag -- 是否已经过户
            ,guarantyvalue -- 抵债资产价值
            ,guarantyrightid -- 产权证书编号
            ,assetsource -- 抵债资产来源
            ,guadebitsum -- 回收抵债资产金额
            ,resourcesystem -- 数据来源系统
            ,quickcashprice -- 快速变现价
            ,guarantybalance -- 抵债资产余额
            ,updatedate -- 更新时间
            ,subjectno -- 抵债资产入账科目
            ,guarantyownername -- 抵债资产所有人
            ,evalvalue -- 评估价值
            ,payedvalue -- 抵债金额
            ,guarantycondition -- 抵债资产目前的状况
            ,inputdate -- 登记时间
            ,assetcategory -- 资产分类
            ,firstevalvalue -- 授信时评估价值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_guaranty_info_op(
            guarantyid -- 抵债资产编号
            ,guarantytype -- 抵债物类型
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,evalorgid -- 评估公司ID
            ,guarantymanager -- 抵债资产管理人
            ,guarantyownerid -- 抵债资产所有人ID
            ,firstevalorgid -- 授信时评估公司ID
            ,debtassetstatus -- 抵债资产状态
            ,evalorgname -- 评估公司名称
            ,firstevalcurrency -- 授信时评估币种
            ,evaldate -- 评估日期
            ,evalcurrency -- 评估币种
            ,tmsp -- 时间戳
            ,deleteflag -- 删除标志
            ,guapreparesum -- 抵债资产的减值准备
            ,guaacctsum -- 抵债资产入账价值
            ,firstevalorgname -- 授信时评估公司名称
            ,updateorgid -- 更新机构
            ,guarantyname -- 抵债资产名称
            ,guarantylist -- 押品细类
            ,guarantylocation -- 抵债资产存放地点
            ,guarantymanagerid -- 抵债资产管理人ID
            ,transferflag -- 是否已经过户
            ,guarantyvalue -- 抵债资产价值
            ,guarantyrightid -- 产权证书编号
            ,assetsource -- 抵债资产来源
            ,guadebitsum -- 回收抵债资产金额
            ,resourcesystem -- 数据来源系统
            ,quickcashprice -- 快速变现价
            ,guarantybalance -- 抵债资产余额
            ,updatedate -- 更新时间
            ,subjectno -- 抵债资产入账科目
            ,guarantyownername -- 抵债资产所有人
            ,evalvalue -- 评估价值
            ,payedvalue -- 抵债金额
            ,guarantycondition -- 抵债资产目前的状况
            ,inputdate -- 登记时间
            ,assetcategory -- 资产分类
            ,firstevalvalue -- 授信时评估价值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.guarantyid, o.guarantyid) as guarantyid -- 抵债资产编号
    ,nvl(n.guarantytype, o.guarantytype) as guarantytype -- 抵债物类型
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.evalorgid, o.evalorgid) as evalorgid -- 评估公司ID
    ,nvl(n.guarantymanager, o.guarantymanager) as guarantymanager -- 抵债资产管理人
    ,nvl(n.guarantyownerid, o.guarantyownerid) as guarantyownerid -- 抵债资产所有人ID
    ,nvl(n.firstevalorgid, o.firstevalorgid) as firstevalorgid -- 授信时评估公司ID
    ,nvl(n.debtassetstatus, o.debtassetstatus) as debtassetstatus -- 抵债资产状态
    ,nvl(n.evalorgname, o.evalorgname) as evalorgname -- 评估公司名称
    ,nvl(n.firstevalcurrency, o.firstevalcurrency) as firstevalcurrency -- 授信时评估币种
    ,nvl(n.evaldate, o.evaldate) as evaldate -- 评估日期
    ,nvl(n.evalcurrency, o.evalcurrency) as evalcurrency -- 评估币种
    ,nvl(n.tmsp, o.tmsp) as tmsp -- 时间戳
    ,nvl(n.deleteflag, o.deleteflag) as deleteflag -- 删除标志
    ,nvl(n.guapreparesum, o.guapreparesum) as guapreparesum -- 抵债资产的减值准备
    ,nvl(n.guaacctsum, o.guaacctsum) as guaacctsum -- 抵债资产入账价值
    ,nvl(n.firstevalorgname, o.firstevalorgname) as firstevalorgname -- 授信时评估公司名称
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.guarantyname, o.guarantyname) as guarantyname -- 抵债资产名称
    ,nvl(n.guarantylist, o.guarantylist) as guarantylist -- 押品细类
    ,nvl(n.guarantylocation, o.guarantylocation) as guarantylocation -- 抵债资产存放地点
    ,nvl(n.guarantymanagerid, o.guarantymanagerid) as guarantymanagerid -- 抵债资产管理人ID
    ,nvl(n.transferflag, o.transferflag) as transferflag -- 是否已经过户
    ,nvl(n.guarantyvalue, o.guarantyvalue) as guarantyvalue -- 抵债资产价值
    ,nvl(n.guarantyrightid, o.guarantyrightid) as guarantyrightid -- 产权证书编号
    ,nvl(n.assetsource, o.assetsource) as assetsource -- 抵债资产来源
    ,nvl(n.guadebitsum, o.guadebitsum) as guadebitsum -- 回收抵债资产金额
    ,nvl(n.resourcesystem, o.resourcesystem) as resourcesystem -- 数据来源系统
    ,nvl(n.quickcashprice, o.quickcashprice) as quickcashprice -- 快速变现价
    ,nvl(n.guarantybalance, o.guarantybalance) as guarantybalance -- 抵债资产余额
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,nvl(n.subjectno, o.subjectno) as subjectno -- 抵债资产入账科目
    ,nvl(n.guarantyownername, o.guarantyownername) as guarantyownername -- 抵债资产所有人
    ,nvl(n.evalvalue, o.evalvalue) as evalvalue -- 评估价值
    ,nvl(n.payedvalue, o.payedvalue) as payedvalue -- 抵债金额
    ,nvl(n.guarantycondition, o.guarantycondition) as guarantycondition -- 抵债资产目前的状况
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.assetcategory, o.assetcategory) as assetcategory -- 资产分类
    ,nvl(n.firstevalvalue, o.firstevalvalue) as firstevalvalue -- 授信时评估价值
    ,case when
            n.guarantyid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.guarantyid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.guarantyid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_guaranty_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_guaranty_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.guarantyid = n.guarantyid
where (
        o.guarantyid is null
    )
    or (
        n.guarantyid is null
    )
    or (
        o.guarantytype <> n.guarantytype
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.updateuserid <> n.updateuserid
        or o.evalorgid <> n.evalorgid
        or o.guarantymanager <> n.guarantymanager
        or o.guarantyownerid <> n.guarantyownerid
        or o.firstevalorgid <> n.firstevalorgid
        or o.debtassetstatus <> n.debtassetstatus
        or o.evalorgname <> n.evalorgname
        or o.firstevalcurrency <> n.firstevalcurrency
        or o.evaldate <> n.evaldate
        or o.evalcurrency <> n.evalcurrency
        or o.tmsp <> n.tmsp
        or o.deleteflag <> n.deleteflag
        or o.guapreparesum <> n.guapreparesum
        or o.guaacctsum <> n.guaacctsum
        or o.firstevalorgname <> n.firstevalorgname
        or o.updateorgid <> n.updateorgid
        or o.guarantyname <> n.guarantyname
        or o.guarantylist <> n.guarantylist
        or o.guarantylocation <> n.guarantylocation
        or o.guarantymanagerid <> n.guarantymanagerid
        or o.transferflag <> n.transferflag
        or o.guarantyvalue <> n.guarantyvalue
        or o.guarantyrightid <> n.guarantyrightid
        or o.assetsource <> n.assetsource
        or o.guadebitsum <> n.guadebitsum
        or o.resourcesystem <> n.resourcesystem
        or o.quickcashprice <> n.quickcashprice
        or o.guarantybalance <> n.guarantybalance
        or o.updatedate <> n.updatedate
        or o.subjectno <> n.subjectno
        or o.guarantyownername <> n.guarantyownername
        or o.evalvalue <> n.evalvalue
        or o.payedvalue <> n.payedvalue
        or o.guarantycondition <> n.guarantycondition
        or o.inputdate <> n.inputdate
        or o.assetcategory <> n.assetcategory
        or o.firstevalvalue <> n.firstevalvalue
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_guaranty_info_cl(
            guarantyid -- 抵债资产编号
            ,guarantytype -- 抵债物类型
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,evalorgid -- 评估公司ID
            ,guarantymanager -- 抵债资产管理人
            ,guarantyownerid -- 抵债资产所有人ID
            ,firstevalorgid -- 授信时评估公司ID
            ,debtassetstatus -- 抵债资产状态
            ,evalorgname -- 评估公司名称
            ,firstevalcurrency -- 授信时评估币种
            ,evaldate -- 评估日期
            ,evalcurrency -- 评估币种
            ,tmsp -- 时间戳
            ,deleteflag -- 删除标志
            ,guapreparesum -- 抵债资产的减值准备
            ,guaacctsum -- 抵债资产入账价值
            ,firstevalorgname -- 授信时评估公司名称
            ,updateorgid -- 更新机构
            ,guarantyname -- 抵债资产名称
            ,guarantylist -- 押品细类
            ,guarantylocation -- 抵债资产存放地点
            ,guarantymanagerid -- 抵债资产管理人ID
            ,transferflag -- 是否已经过户
            ,guarantyvalue -- 抵债资产价值
            ,guarantyrightid -- 产权证书编号
            ,assetsource -- 抵债资产来源
            ,guadebitsum -- 回收抵债资产金额
            ,resourcesystem -- 数据来源系统
            ,quickcashprice -- 快速变现价
            ,guarantybalance -- 抵债资产余额
            ,updatedate -- 更新时间
            ,subjectno -- 抵债资产入账科目
            ,guarantyownername -- 抵债资产所有人
            ,evalvalue -- 评估价值
            ,payedvalue -- 抵债金额
            ,guarantycondition -- 抵债资产目前的状况
            ,inputdate -- 登记时间
            ,assetcategory -- 资产分类
            ,firstevalvalue -- 授信时评估价值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_guaranty_info_op(
            guarantyid -- 抵债资产编号
            ,guarantytype -- 抵债物类型
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,evalorgid -- 评估公司ID
            ,guarantymanager -- 抵债资产管理人
            ,guarantyownerid -- 抵债资产所有人ID
            ,firstevalorgid -- 授信时评估公司ID
            ,debtassetstatus -- 抵债资产状态
            ,evalorgname -- 评估公司名称
            ,firstevalcurrency -- 授信时评估币种
            ,evaldate -- 评估日期
            ,evalcurrency -- 评估币种
            ,tmsp -- 时间戳
            ,deleteflag -- 删除标志
            ,guapreparesum -- 抵债资产的减值准备
            ,guaacctsum -- 抵债资产入账价值
            ,firstevalorgname -- 授信时评估公司名称
            ,updateorgid -- 更新机构
            ,guarantyname -- 抵债资产名称
            ,guarantylist -- 押品细类
            ,guarantylocation -- 抵债资产存放地点
            ,guarantymanagerid -- 抵债资产管理人ID
            ,transferflag -- 是否已经过户
            ,guarantyvalue -- 抵债资产价值
            ,guarantyrightid -- 产权证书编号
            ,assetsource -- 抵债资产来源
            ,guadebitsum -- 回收抵债资产金额
            ,resourcesystem -- 数据来源系统
            ,quickcashprice -- 快速变现价
            ,guarantybalance -- 抵债资产余额
            ,updatedate -- 更新时间
            ,subjectno -- 抵债资产入账科目
            ,guarantyownername -- 抵债资产所有人
            ,evalvalue -- 评估价值
            ,payedvalue -- 抵债金额
            ,guarantycondition -- 抵债资产目前的状况
            ,inputdate -- 登记时间
            ,assetcategory -- 资产分类
            ,firstevalvalue -- 授信时评估价值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.guarantyid -- 抵债资产编号
    ,o.guarantytype -- 抵债物类型
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.updateuserid -- 更新人
    ,o.evalorgid -- 评估公司ID
    ,o.guarantymanager -- 抵债资产管理人
    ,o.guarantyownerid -- 抵债资产所有人ID
    ,o.firstevalorgid -- 授信时评估公司ID
    ,o.debtassetstatus -- 抵债资产状态
    ,o.evalorgname -- 评估公司名称
    ,o.firstevalcurrency -- 授信时评估币种
    ,o.evaldate -- 评估日期
    ,o.evalcurrency -- 评估币种
    ,o.tmsp -- 时间戳
    ,o.deleteflag -- 删除标志
    ,o.guapreparesum -- 抵债资产的减值准备
    ,o.guaacctsum -- 抵债资产入账价值
    ,o.firstevalorgname -- 授信时评估公司名称
    ,o.updateorgid -- 更新机构
    ,o.guarantyname -- 抵债资产名称
    ,o.guarantylist -- 押品细类
    ,o.guarantylocation -- 抵债资产存放地点
    ,o.guarantymanagerid -- 抵债资产管理人ID
    ,o.transferflag -- 是否已经过户
    ,o.guarantyvalue -- 抵债资产价值
    ,o.guarantyrightid -- 产权证书编号
    ,o.assetsource -- 抵债资产来源
    ,o.guadebitsum -- 回收抵债资产金额
    ,o.resourcesystem -- 数据来源系统
    ,o.quickcashprice -- 快速变现价
    ,o.guarantybalance -- 抵债资产余额
    ,o.updatedate -- 更新时间
    ,o.subjectno -- 抵债资产入账科目
    ,o.guarantyownername -- 抵债资产所有人
    ,o.evalvalue -- 评估价值
    ,o.payedvalue -- 抵债金额
    ,o.guarantycondition -- 抵债资产目前的状况
    ,o.inputdate -- 登记时间
    ,o.assetcategory -- 资产分类
    ,o.firstevalvalue -- 授信时评估价值
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
from ${iol_schema}.icms_ap_guaranty_info_bk o
    left join ${iol_schema}.icms_ap_guaranty_info_op n
        on
            o.guarantyid = n.guarantyid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_guaranty_info_cl d
        on
            o.guarantyid = d.guarantyid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_guaranty_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_guaranty_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_guaranty_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_guaranty_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_guaranty_info exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_guaranty_info_cl;
alter table ${iol_schema}.icms_ap_guaranty_info exchange partition p_20991231 with table ${iol_schema}.icms_ap_guaranty_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_guaranty_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_guaranty_info_op purge;
drop table ${iol_schema}.icms_ap_guaranty_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_guaranty_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_guaranty_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
