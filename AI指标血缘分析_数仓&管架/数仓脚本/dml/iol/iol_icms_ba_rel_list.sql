/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ba_rel_list
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
create table ${iol_schema}.icms_ba_rel_list_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ba_rel_list
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ba_rel_list_op purge;
drop table ${iol_schema}.icms_ba_rel_list_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ba_rel_list_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ba_rel_list where 0=1;

create table ${iol_schema}.icms_ba_rel_list_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ba_rel_list where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ba_rel_list_cl(
            serialno -- 主键
            ,relativeserialno -- 业务流水号
            ,relpartneridno -- 关联人配偶证件号码
            ,pledgepkno -- 智贷质押物信息主键
            ,relidtype -- 关联人证件类型
            ,relmarriage -- 关联人婚姻状况
            ,relpartnername -- 关联人配偶姓名
            ,updatedate -- 更新时间
            ,ownshare -- 抵押人对抵押物拥有的份额
            ,businessesflag -- 客户性质
            ,conshr -- 智贷权利人共有份额
            ,relpartneridtype -- 关联人配偶证件类型
            ,cusid -- 客户号
            ,naturecategoryrel -- 关联人户籍性质
            ,reltyp -- 关联人类型
            ,reltelno -- 关联人手机号码
            ,relpartnertelno -- 关联人配偶手机号码
            ,relidno -- 关联人证件号码
            ,relname -- 关联人姓名
            ,remark -- 备注
            ,immovables -- 不动产共有情况
            ,naturecategoryrelsps -- 关联人配偶户籍性质
            ,eduexperiencerel -- 关联人学历
            ,relfamilyaddr -- 关联人居住地址
            ,fqzresult -- 反欺诈结果
            ,zxresult -- 征信结果
            ,agriflg -- 是否农户
            ,relfamilycityid -- 关联人居住地址城市编号
            ,oblityp -- 智贷去权利人类型
            ,relrelationship -- 与主借款人关系
            ,migtflag -- 
            ,relidexpire -- 关联人证件到期日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ba_rel_list_op(
            serialno -- 主键
            ,relativeserialno -- 业务流水号
            ,relpartneridno -- 关联人配偶证件号码
            ,pledgepkno -- 智贷质押物信息主键
            ,relidtype -- 关联人证件类型
            ,relmarriage -- 关联人婚姻状况
            ,relpartnername -- 关联人配偶姓名
            ,updatedate -- 更新时间
            ,ownshare -- 抵押人对抵押物拥有的份额
            ,businessesflag -- 客户性质
            ,conshr -- 智贷权利人共有份额
            ,relpartneridtype -- 关联人配偶证件类型
            ,cusid -- 客户号
            ,naturecategoryrel -- 关联人户籍性质
            ,reltyp -- 关联人类型
            ,reltelno -- 关联人手机号码
            ,relpartnertelno -- 关联人配偶手机号码
            ,relidno -- 关联人证件号码
            ,relname -- 关联人姓名
            ,remark -- 备注
            ,immovables -- 不动产共有情况
            ,naturecategoryrelsps -- 关联人配偶户籍性质
            ,eduexperiencerel -- 关联人学历
            ,relfamilyaddr -- 关联人居住地址
            ,fqzresult -- 反欺诈结果
            ,zxresult -- 征信结果
            ,agriflg -- 是否农户
            ,relfamilycityid -- 关联人居住地址城市编号
            ,oblityp -- 智贷去权利人类型
            ,relrelationship -- 与主借款人关系
            ,migtflag -- 
            ,relidexpire -- 关联人证件到期日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 主键
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 业务流水号
    ,nvl(n.relpartneridno, o.relpartneridno) as relpartneridno -- 关联人配偶证件号码
    ,nvl(n.pledgepkno, o.pledgepkno) as pledgepkno -- 智贷质押物信息主键
    ,nvl(n.relidtype, o.relidtype) as relidtype -- 关联人证件类型
    ,nvl(n.relmarriage, o.relmarriage) as relmarriage -- 关联人婚姻状况
    ,nvl(n.relpartnername, o.relpartnername) as relpartnername -- 关联人配偶姓名
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,nvl(n.ownshare, o.ownshare) as ownshare -- 抵押人对抵押物拥有的份额
    ,nvl(n.businessesflag, o.businessesflag) as businessesflag -- 客户性质
    ,nvl(n.conshr, o.conshr) as conshr -- 智贷权利人共有份额
    ,nvl(n.relpartneridtype, o.relpartneridtype) as relpartneridtype -- 关联人配偶证件类型
    ,nvl(n.cusid, o.cusid) as cusid -- 客户号
    ,nvl(n.naturecategoryrel, o.naturecategoryrel) as naturecategoryrel -- 关联人户籍性质
    ,nvl(n.reltyp, o.reltyp) as reltyp -- 关联人类型
    ,nvl(n.reltelno, o.reltelno) as reltelno -- 关联人手机号码
    ,nvl(n.relpartnertelno, o.relpartnertelno) as relpartnertelno -- 关联人配偶手机号码
    ,nvl(n.relidno, o.relidno) as relidno -- 关联人证件号码
    ,nvl(n.relname, o.relname) as relname -- 关联人姓名
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.immovables, o.immovables) as immovables -- 不动产共有情况
    ,nvl(n.naturecategoryrelsps, o.naturecategoryrelsps) as naturecategoryrelsps -- 关联人配偶户籍性质
    ,nvl(n.eduexperiencerel, o.eduexperiencerel) as eduexperiencerel -- 关联人学历
    ,nvl(n.relfamilyaddr, o.relfamilyaddr) as relfamilyaddr -- 关联人居住地址
    ,nvl(n.fqzresult, o.fqzresult) as fqzresult -- 反欺诈结果
    ,nvl(n.zxresult, o.zxresult) as zxresult -- 征信结果
    ,nvl(n.agriflg, o.agriflg) as agriflg -- 是否农户
    ,nvl(n.relfamilycityid, o.relfamilycityid) as relfamilycityid -- 关联人居住地址城市编号
    ,nvl(n.oblityp, o.oblityp) as oblityp -- 智贷去权利人类型
    ,nvl(n.relrelationship, o.relrelationship) as relrelationship -- 与主借款人关系
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.relidexpire, o.relidexpire) as relidexpire -- 关联人证件到期日
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
from (select * from ${iol_schema}.icms_ba_rel_list_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ba_rel_list where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.relativeserialno <> n.relativeserialno
        or o.relpartneridno <> n.relpartneridno
        or o.pledgepkno <> n.pledgepkno
        or o.relidtype <> n.relidtype
        or o.relmarriage <> n.relmarriage
        or o.relpartnername <> n.relpartnername
        or o.updatedate <> n.updatedate
        or o.ownshare <> n.ownshare
        or o.businessesflag <> n.businessesflag
        or o.conshr <> n.conshr
        or o.relpartneridtype <> n.relpartneridtype
        or o.cusid <> n.cusid
        or o.naturecategoryrel <> n.naturecategoryrel
        or o.reltyp <> n.reltyp
        or o.reltelno <> n.reltelno
        or o.relpartnertelno <> n.relpartnertelno
        or o.relidno <> n.relidno
        or o.relname <> n.relname
        or o.remark <> n.remark
        or o.immovables <> n.immovables
        or o.naturecategoryrelsps <> n.naturecategoryrelsps
        or o.eduexperiencerel <> n.eduexperiencerel
        or o.relfamilyaddr <> n.relfamilyaddr
        or o.fqzresult <> n.fqzresult
        or o.zxresult <> n.zxresult
        or o.agriflg <> n.agriflg
        or o.relfamilycityid <> n.relfamilycityid
        or o.oblityp <> n.oblityp
        or o.relrelationship <> n.relrelationship
        or o.migtflag <> n.migtflag
        or o.relidexpire <> n.relidexpire
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ba_rel_list_cl(
            serialno -- 主键
            ,relativeserialno -- 业务流水号
            ,relpartneridno -- 关联人配偶证件号码
            ,pledgepkno -- 智贷质押物信息主键
            ,relidtype -- 关联人证件类型
            ,relmarriage -- 关联人婚姻状况
            ,relpartnername -- 关联人配偶姓名
            ,updatedate -- 更新时间
            ,ownshare -- 抵押人对抵押物拥有的份额
            ,businessesflag -- 客户性质
            ,conshr -- 智贷权利人共有份额
            ,relpartneridtype -- 关联人配偶证件类型
            ,cusid -- 客户号
            ,naturecategoryrel -- 关联人户籍性质
            ,reltyp -- 关联人类型
            ,reltelno -- 关联人手机号码
            ,relpartnertelno -- 关联人配偶手机号码
            ,relidno -- 关联人证件号码
            ,relname -- 关联人姓名
            ,remark -- 备注
            ,immovables -- 不动产共有情况
            ,naturecategoryrelsps -- 关联人配偶户籍性质
            ,eduexperiencerel -- 关联人学历
            ,relfamilyaddr -- 关联人居住地址
            ,fqzresult -- 反欺诈结果
            ,zxresult -- 征信结果
            ,agriflg -- 是否农户
            ,relfamilycityid -- 关联人居住地址城市编号
            ,oblityp -- 智贷去权利人类型
            ,relrelationship -- 与主借款人关系
            ,migtflag -- 
            ,relidexpire -- 关联人证件到期日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ba_rel_list_op(
            serialno -- 主键
            ,relativeserialno -- 业务流水号
            ,relpartneridno -- 关联人配偶证件号码
            ,pledgepkno -- 智贷质押物信息主键
            ,relidtype -- 关联人证件类型
            ,relmarriage -- 关联人婚姻状况
            ,relpartnername -- 关联人配偶姓名
            ,updatedate -- 更新时间
            ,ownshare -- 抵押人对抵押物拥有的份额
            ,businessesflag -- 客户性质
            ,conshr -- 智贷权利人共有份额
            ,relpartneridtype -- 关联人配偶证件类型
            ,cusid -- 客户号
            ,naturecategoryrel -- 关联人户籍性质
            ,reltyp -- 关联人类型
            ,reltelno -- 关联人手机号码
            ,relpartnertelno -- 关联人配偶手机号码
            ,relidno -- 关联人证件号码
            ,relname -- 关联人姓名
            ,remark -- 备注
            ,immovables -- 不动产共有情况
            ,naturecategoryrelsps -- 关联人配偶户籍性质
            ,eduexperiencerel -- 关联人学历
            ,relfamilyaddr -- 关联人居住地址
            ,fqzresult -- 反欺诈结果
            ,zxresult -- 征信结果
            ,agriflg -- 是否农户
            ,relfamilycityid -- 关联人居住地址城市编号
            ,oblityp -- 智贷去权利人类型
            ,relrelationship -- 与主借款人关系
            ,migtflag -- 
            ,relidexpire -- 关联人证件到期日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 主键
    ,o.relativeserialno -- 业务流水号
    ,o.relpartneridno -- 关联人配偶证件号码
    ,o.pledgepkno -- 智贷质押物信息主键
    ,o.relidtype -- 关联人证件类型
    ,o.relmarriage -- 关联人婚姻状况
    ,o.relpartnername -- 关联人配偶姓名
    ,o.updatedate -- 更新时间
    ,o.ownshare -- 抵押人对抵押物拥有的份额
    ,o.businessesflag -- 客户性质
    ,o.conshr -- 智贷权利人共有份额
    ,o.relpartneridtype -- 关联人配偶证件类型
    ,o.cusid -- 客户号
    ,o.naturecategoryrel -- 关联人户籍性质
    ,o.reltyp -- 关联人类型
    ,o.reltelno -- 关联人手机号码
    ,o.relpartnertelno -- 关联人配偶手机号码
    ,o.relidno -- 关联人证件号码
    ,o.relname -- 关联人姓名
    ,o.remark -- 备注
    ,o.immovables -- 不动产共有情况
    ,o.naturecategoryrelsps -- 关联人配偶户籍性质
    ,o.eduexperiencerel -- 关联人学历
    ,o.relfamilyaddr -- 关联人居住地址
    ,o.fqzresult -- 反欺诈结果
    ,o.zxresult -- 征信结果
    ,o.agriflg -- 是否农户
    ,o.relfamilycityid -- 关联人居住地址城市编号
    ,o.oblityp -- 智贷去权利人类型
    ,o.relrelationship -- 与主借款人关系
    ,o.migtflag -- 
    ,o.relidexpire -- 关联人证件到期日
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
from ${iol_schema}.icms_ba_rel_list_bk o
    left join ${iol_schema}.icms_ba_rel_list_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ba_rel_list_cl d
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
--truncate table ${iol_schema}.icms_ba_rel_list;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ba_rel_list') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ba_rel_list drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ba_rel_list add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ba_rel_list exchange partition p_${batch_date} with table ${iol_schema}.icms_ba_rel_list_cl;
alter table ${iol_schema}.icms_ba_rel_list exchange partition p_20991231 with table ${iol_schema}.icms_ba_rel_list_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ba_rel_list to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ba_rel_list_op purge;
drop table ${iol_schema}.icms_ba_rel_list_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ba_rel_list_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ba_rel_list',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
