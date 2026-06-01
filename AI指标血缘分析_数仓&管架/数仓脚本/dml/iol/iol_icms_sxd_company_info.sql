/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_sxd_company_info
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
create table ${iol_schema}.icms_sxd_company_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_sxd_company_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_sxd_company_info_op purge;
drop table ${iol_schema}.icms_sxd_company_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_sxd_company_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_sxd_company_info where 0=1;

create table ${iol_schema}.icms_sxd_company_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_sxd_company_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_sxd_company_info_cl(
            serno -- 业务流水号
            ,yyqx -- 营业期限(到期日)
            ,zcdz -- 注册地址
            ,jyfw -- 经营范围
            ,fddbrmc -- 法定代表人姓名
            ,frdydz -- 法定代表人电子邮箱
            ,gszch -- 工商注册号
            ,zjlx -- 证件类型
            ,fryddhhm -- 法定代表人移动电话号码
            ,hymxmc -- 行业名称
            ,frgddhhm -- 法定代表人电话号码
            ,xydj -- 纳税信用等级
            ,dmgyxzqh -- 企业注册地行政地区码
            ,nsrmc -- 纳税人名称
            ,zczbze -- 注册资本
            ,frzjlxmc -- 法定代表人证件类型
            ,frzjhm -- 法定代表人证件号码
            ,zgswjgmc -- 主管税务机关名称
            ,dhhm -- 联系电话
            ,djrq -- 登记（开业）日期
            ,sykjzddm -- 适用会计制度
            ,migtflag -- 
            ,scjydz -- 营业地址
            ,hymxdm -- 行业代码
            ,nsrlx -- 纳税类型
            ,xypfsj -- 评级时间
            ,nsrsbh -- 纳税人识别号
            ,zzjgdm -- 组织机构代码
            ,cyrs -- 从业人数
            ,nsrzt -- 纳税人状态
            ,ds -- 企业所在市
            ,hzrq -- 核准日期
            ,djzclxdm -- 企业登记注册类型代码
            ,zcbzmc -- 注册资本币种
            ,dmgyjdxz -- 企业注册地街道地区码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_sxd_company_info_op(
            serno -- 业务流水号
            ,yyqx -- 营业期限(到期日)
            ,zcdz -- 注册地址
            ,jyfw -- 经营范围
            ,fddbrmc -- 法定代表人姓名
            ,frdydz -- 法定代表人电子邮箱
            ,gszch -- 工商注册号
            ,zjlx -- 证件类型
            ,fryddhhm -- 法定代表人移动电话号码
            ,hymxmc -- 行业名称
            ,frgddhhm -- 法定代表人电话号码
            ,xydj -- 纳税信用等级
            ,dmgyxzqh -- 企业注册地行政地区码
            ,nsrmc -- 纳税人名称
            ,zczbze -- 注册资本
            ,frzjlxmc -- 法定代表人证件类型
            ,frzjhm -- 法定代表人证件号码
            ,zgswjgmc -- 主管税务机关名称
            ,dhhm -- 联系电话
            ,djrq -- 登记（开业）日期
            ,sykjzddm -- 适用会计制度
            ,migtflag -- 
            ,scjydz -- 营业地址
            ,hymxdm -- 行业代码
            ,nsrlx -- 纳税类型
            ,xypfsj -- 评级时间
            ,nsrsbh -- 纳税人识别号
            ,zzjgdm -- 组织机构代码
            ,cyrs -- 从业人数
            ,nsrzt -- 纳税人状态
            ,ds -- 企业所在市
            ,hzrq -- 核准日期
            ,djzclxdm -- 企业登记注册类型代码
            ,zcbzmc -- 注册资本币种
            ,dmgyjdxz -- 企业注册地街道地区码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serno, o.serno) as serno -- 业务流水号
    ,nvl(n.yyqx, o.yyqx) as yyqx -- 营业期限(到期日)
    ,nvl(n.zcdz, o.zcdz) as zcdz -- 注册地址
    ,nvl(n.jyfw, o.jyfw) as jyfw -- 经营范围
    ,nvl(n.fddbrmc, o.fddbrmc) as fddbrmc -- 法定代表人姓名
    ,nvl(n.frdydz, o.frdydz) as frdydz -- 法定代表人电子邮箱
    ,nvl(n.gszch, o.gszch) as gszch -- 工商注册号
    ,nvl(n.zjlx, o.zjlx) as zjlx -- 证件类型
    ,nvl(n.fryddhhm, o.fryddhhm) as fryddhhm -- 法定代表人移动电话号码
    ,nvl(n.hymxmc, o.hymxmc) as hymxmc -- 行业名称
    ,nvl(n.frgddhhm, o.frgddhhm) as frgddhhm -- 法定代表人电话号码
    ,nvl(n.xydj, o.xydj) as xydj -- 纳税信用等级
    ,nvl(n.dmgyxzqh, o.dmgyxzqh) as dmgyxzqh -- 企业注册地行政地区码
    ,nvl(n.nsrmc, o.nsrmc) as nsrmc -- 纳税人名称
    ,nvl(n.zczbze, o.zczbze) as zczbze -- 注册资本
    ,nvl(n.frzjlxmc, o.frzjlxmc) as frzjlxmc -- 法定代表人证件类型
    ,nvl(n.frzjhm, o.frzjhm) as frzjhm -- 法定代表人证件号码
    ,nvl(n.zgswjgmc, o.zgswjgmc) as zgswjgmc -- 主管税务机关名称
    ,nvl(n.dhhm, o.dhhm) as dhhm -- 联系电话
    ,nvl(n.djrq, o.djrq) as djrq -- 登记（开业）日期
    ,nvl(n.sykjzddm, o.sykjzddm) as sykjzddm -- 适用会计制度
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.scjydz, o.scjydz) as scjydz -- 营业地址
    ,nvl(n.hymxdm, o.hymxdm) as hymxdm -- 行业代码
    ,nvl(n.nsrlx, o.nsrlx) as nsrlx -- 纳税类型
    ,nvl(n.xypfsj, o.xypfsj) as xypfsj -- 评级时间
    ,nvl(n.nsrsbh, o.nsrsbh) as nsrsbh -- 纳税人识别号
    ,nvl(n.zzjgdm, o.zzjgdm) as zzjgdm -- 组织机构代码
    ,nvl(n.cyrs, o.cyrs) as cyrs -- 从业人数
    ,nvl(n.nsrzt, o.nsrzt) as nsrzt -- 纳税人状态
    ,nvl(n.ds, o.ds) as ds -- 企业所在市
    ,nvl(n.hzrq, o.hzrq) as hzrq -- 核准日期
    ,nvl(n.djzclxdm, o.djzclxdm) as djzclxdm -- 企业登记注册类型代码
    ,nvl(n.zcbzmc, o.zcbzmc) as zcbzmc -- 注册资本币种
    ,nvl(n.dmgyjdxz, o.dmgyjdxz) as dmgyjdxz -- 企业注册地街道地区码
    ,case when
            n.serno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_sxd_company_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_sxd_company_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serno = n.serno
where (
        o.serno is null
    )
    or (
        n.serno is null
    )
    or (
        o.yyqx <> n.yyqx
        or o.zcdz <> n.zcdz
        or o.jyfw <> n.jyfw
        or o.fddbrmc <> n.fddbrmc
        or o.frdydz <> n.frdydz
        or o.gszch <> n.gszch
        or o.zjlx <> n.zjlx
        or o.fryddhhm <> n.fryddhhm
        or o.hymxmc <> n.hymxmc
        or o.frgddhhm <> n.frgddhhm
        or o.xydj <> n.xydj
        or o.dmgyxzqh <> n.dmgyxzqh
        or o.nsrmc <> n.nsrmc
        or o.zczbze <> n.zczbze
        or o.frzjlxmc <> n.frzjlxmc
        or o.frzjhm <> n.frzjhm
        or o.zgswjgmc <> n.zgswjgmc
        or o.dhhm <> n.dhhm
        or o.djrq <> n.djrq
        or o.sykjzddm <> n.sykjzddm
        or o.migtflag <> n.migtflag
        or o.scjydz <> n.scjydz
        or o.hymxdm <> n.hymxdm
        or o.nsrlx <> n.nsrlx
        or o.xypfsj <> n.xypfsj
        or o.nsrsbh <> n.nsrsbh
        or o.zzjgdm <> n.zzjgdm
        or o.cyrs <> n.cyrs
        or o.nsrzt <> n.nsrzt
        or o.ds <> n.ds
        or o.hzrq <> n.hzrq
        or o.djzclxdm <> n.djzclxdm
        or o.zcbzmc <> n.zcbzmc
        or o.dmgyjdxz <> n.dmgyjdxz
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_sxd_company_info_cl(
            serno -- 业务流水号
            ,yyqx -- 营业期限(到期日)
            ,zcdz -- 注册地址
            ,jyfw -- 经营范围
            ,fddbrmc -- 法定代表人姓名
            ,frdydz -- 法定代表人电子邮箱
            ,gszch -- 工商注册号
            ,zjlx -- 证件类型
            ,fryddhhm -- 法定代表人移动电话号码
            ,hymxmc -- 行业名称
            ,frgddhhm -- 法定代表人电话号码
            ,xydj -- 纳税信用等级
            ,dmgyxzqh -- 企业注册地行政地区码
            ,nsrmc -- 纳税人名称
            ,zczbze -- 注册资本
            ,frzjlxmc -- 法定代表人证件类型
            ,frzjhm -- 法定代表人证件号码
            ,zgswjgmc -- 主管税务机关名称
            ,dhhm -- 联系电话
            ,djrq -- 登记（开业）日期
            ,sykjzddm -- 适用会计制度
            ,migtflag -- 
            ,scjydz -- 营业地址
            ,hymxdm -- 行业代码
            ,nsrlx -- 纳税类型
            ,xypfsj -- 评级时间
            ,nsrsbh -- 纳税人识别号
            ,zzjgdm -- 组织机构代码
            ,cyrs -- 从业人数
            ,nsrzt -- 纳税人状态
            ,ds -- 企业所在市
            ,hzrq -- 核准日期
            ,djzclxdm -- 企业登记注册类型代码
            ,zcbzmc -- 注册资本币种
            ,dmgyjdxz -- 企业注册地街道地区码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_sxd_company_info_op(
            serno -- 业务流水号
            ,yyqx -- 营业期限(到期日)
            ,zcdz -- 注册地址
            ,jyfw -- 经营范围
            ,fddbrmc -- 法定代表人姓名
            ,frdydz -- 法定代表人电子邮箱
            ,gszch -- 工商注册号
            ,zjlx -- 证件类型
            ,fryddhhm -- 法定代表人移动电话号码
            ,hymxmc -- 行业名称
            ,frgddhhm -- 法定代表人电话号码
            ,xydj -- 纳税信用等级
            ,dmgyxzqh -- 企业注册地行政地区码
            ,nsrmc -- 纳税人名称
            ,zczbze -- 注册资本
            ,frzjlxmc -- 法定代表人证件类型
            ,frzjhm -- 法定代表人证件号码
            ,zgswjgmc -- 主管税务机关名称
            ,dhhm -- 联系电话
            ,djrq -- 登记（开业）日期
            ,sykjzddm -- 适用会计制度
            ,migtflag -- 
            ,scjydz -- 营业地址
            ,hymxdm -- 行业代码
            ,nsrlx -- 纳税类型
            ,xypfsj -- 评级时间
            ,nsrsbh -- 纳税人识别号
            ,zzjgdm -- 组织机构代码
            ,cyrs -- 从业人数
            ,nsrzt -- 纳税人状态
            ,ds -- 企业所在市
            ,hzrq -- 核准日期
            ,djzclxdm -- 企业登记注册类型代码
            ,zcbzmc -- 注册资本币种
            ,dmgyjdxz -- 企业注册地街道地区码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serno -- 业务流水号
    ,o.yyqx -- 营业期限(到期日)
    ,o.zcdz -- 注册地址
    ,o.jyfw -- 经营范围
    ,o.fddbrmc -- 法定代表人姓名
    ,o.frdydz -- 法定代表人电子邮箱
    ,o.gszch -- 工商注册号
    ,o.zjlx -- 证件类型
    ,o.fryddhhm -- 法定代表人移动电话号码
    ,o.hymxmc -- 行业名称
    ,o.frgddhhm -- 法定代表人电话号码
    ,o.xydj -- 纳税信用等级
    ,o.dmgyxzqh -- 企业注册地行政地区码
    ,o.nsrmc -- 纳税人名称
    ,o.zczbze -- 注册资本
    ,o.frzjlxmc -- 法定代表人证件类型
    ,o.frzjhm -- 法定代表人证件号码
    ,o.zgswjgmc -- 主管税务机关名称
    ,o.dhhm -- 联系电话
    ,o.djrq -- 登记（开业）日期
    ,o.sykjzddm -- 适用会计制度
    ,o.migtflag -- 
    ,o.scjydz -- 营业地址
    ,o.hymxdm -- 行业代码
    ,o.nsrlx -- 纳税类型
    ,o.xypfsj -- 评级时间
    ,o.nsrsbh -- 纳税人识别号
    ,o.zzjgdm -- 组织机构代码
    ,o.cyrs -- 从业人数
    ,o.nsrzt -- 纳税人状态
    ,o.ds -- 企业所在市
    ,o.hzrq -- 核准日期
    ,o.djzclxdm -- 企业登记注册类型代码
    ,o.zcbzmc -- 注册资本币种
    ,o.dmgyjdxz -- 企业注册地街道地区码
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
from ${iol_schema}.icms_sxd_company_info_bk o
    left join ${iol_schema}.icms_sxd_company_info_op n
        on
            o.serno = n.serno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_sxd_company_info_cl d
        on
            o.serno = d.serno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_sxd_company_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_sxd_company_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_sxd_company_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_sxd_company_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_sxd_company_info exchange partition p_${batch_date} with table ${iol_schema}.icms_sxd_company_info_cl;
alter table ${iol_schema}.icms_sxd_company_info exchange partition p_20991231 with table ${iol_schema}.icms_sxd_company_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_sxd_company_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_sxd_company_info_op purge;
drop table ${iol_schema}.icms_sxd_company_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_sxd_company_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_sxd_company_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
