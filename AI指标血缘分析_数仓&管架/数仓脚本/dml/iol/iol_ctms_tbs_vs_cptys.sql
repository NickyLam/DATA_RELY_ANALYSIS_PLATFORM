/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_vs_cptys
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
create table ${iol_schema}.ctms_tbs_vs_cptys_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_vs_cptys;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_cptys_op purge;
drop table ${iol_schema}.ctms_tbs_vs_cptys_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_cptys_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_cptys where 0=1;

create table ${iol_schema}.ctms_tbs_vs_cptys_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_cptys where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_cptys_cl(
            cptys_id -- 交易对手ID
            ,aspclient_id -- 部门ID
            ,cptys_shortname -- 交易对手简称
            ,cptys_name -- 交易对手全称
            ,cptys_name2 -- 交易对手名称2
            ,name_src -- 电子证书名称
            ,key_src -- 数字证书号
            ,islink_src -- 是否连接电子证书
            ,lastmodified -- 最后修改时间
            ,datasymbolconfig_id -- 数据源配置ID
            ,label -- 其他系统代号
            ,rating_level -- 内部评级
            ,field1 -- 扩展字段1
            ,field2 -- 扩展字段2
            ,field3 -- 扩展字段3
            ,counterparty_ename -- 交易对手英文名称
            ,counterparty_short_ename -- 交易对手英文简称
            ,contact_name -- 联系人姓名
            ,telephone -- 电话
            ,fax -- 传真
            ,is_issuer -- 是否是发行人
            ,is_bank -- 是否是金融机构
            ,is_guarantee -- 是否是担保人
            ,is_custody -- 是否是托管机构
            ,customer_type_code -- 行业类别code
            ,customer_type_name -- 行业类别name
            ,parent -- 母公司id
            ,ex_code -- 电子联行号
            ,ex_account -- 大额支付系统号
            ,swift_code -- swift电文代号
            ,ref_issuer_id -- 发行人/担保人ID
            ,issuer_name -- 发行人/担保人中文名
            ,cfets_member_attr -- 是否外汇会员
            ,master_short_cname -- 主机构中文短名
            ,master_cfets_id -- 主机构本币会员id
            ,master_cnty_seq -- 主机构系统交易对手编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_cptys_op(
            cptys_id -- 交易对手ID
            ,aspclient_id -- 部门ID
            ,cptys_shortname -- 交易对手简称
            ,cptys_name -- 交易对手全称
            ,cptys_name2 -- 交易对手名称2
            ,name_src -- 电子证书名称
            ,key_src -- 数字证书号
            ,islink_src -- 是否连接电子证书
            ,lastmodified -- 最后修改时间
            ,datasymbolconfig_id -- 数据源配置ID
            ,label -- 其他系统代号
            ,rating_level -- 内部评级
            ,field1 -- 扩展字段1
            ,field2 -- 扩展字段2
            ,field3 -- 扩展字段3
            ,counterparty_ename -- 交易对手英文名称
            ,counterparty_short_ename -- 交易对手英文简称
            ,contact_name -- 联系人姓名
            ,telephone -- 电话
            ,fax -- 传真
            ,is_issuer -- 是否是发行人
            ,is_bank -- 是否是金融机构
            ,is_guarantee -- 是否是担保人
            ,is_custody -- 是否是托管机构
            ,customer_type_code -- 行业类别code
            ,customer_type_name -- 行业类别name
            ,parent -- 母公司id
            ,ex_code -- 电子联行号
            ,ex_account -- 大额支付系统号
            ,swift_code -- swift电文代号
            ,ref_issuer_id -- 发行人/担保人ID
            ,issuer_name -- 发行人/担保人中文名
            ,cfets_member_attr -- 是否外汇会员
            ,master_short_cname -- 主机构中文短名
            ,master_cfets_id -- 主机构本币会员id
            ,master_cnty_seq -- 主机构系统交易对手编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cptys_id, o.cptys_id) as cptys_id -- 交易对手ID
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 部门ID
    ,nvl(n.cptys_shortname, o.cptys_shortname) as cptys_shortname -- 交易对手简称
    ,nvl(n.cptys_name, o.cptys_name) as cptys_name -- 交易对手全称
    ,nvl(n.cptys_name2, o.cptys_name2) as cptys_name2 -- 交易对手名称2
    ,nvl(n.name_src, o.name_src) as name_src -- 电子证书名称
    ,nvl(n.key_src, o.key_src) as key_src -- 数字证书号
    ,nvl(n.islink_src, o.islink_src) as islink_src -- 是否连接电子证书
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 最后修改时间
    ,nvl(n.datasymbolconfig_id, o.datasymbolconfig_id) as datasymbolconfig_id -- 数据源配置ID
    ,nvl(n.label, o.label) as label -- 其他系统代号
    ,nvl(n.rating_level, o.rating_level) as rating_level -- 内部评级
    ,nvl(n.field1, o.field1) as field1 -- 扩展字段1
    ,nvl(n.field2, o.field2) as field2 -- 扩展字段2
    ,nvl(n.field3, o.field3) as field3 -- 扩展字段3
    ,nvl(n.counterparty_ename, o.counterparty_ename) as counterparty_ename -- 交易对手英文名称
    ,nvl(n.counterparty_short_ename, o.counterparty_short_ename) as counterparty_short_ename -- 交易对手英文简称
    ,nvl(n.contact_name, o.contact_name) as contact_name -- 联系人姓名
    ,nvl(n.telephone, o.telephone) as telephone -- 电话
    ,nvl(n.fax, o.fax) as fax -- 传真
    ,nvl(n.is_issuer, o.is_issuer) as is_issuer -- 是否是发行人
    ,nvl(n.is_bank, o.is_bank) as is_bank -- 是否是金融机构
    ,nvl(n.is_guarantee, o.is_guarantee) as is_guarantee -- 是否是担保人
    ,nvl(n.is_custody, o.is_custody) as is_custody -- 是否是托管机构
    ,nvl(n.customer_type_code, o.customer_type_code) as customer_type_code -- 行业类别code
    ,nvl(n.customer_type_name, o.customer_type_name) as customer_type_name -- 行业类别name
    ,nvl(n.parent, o.parent) as parent -- 母公司id
    ,nvl(n.ex_code, o.ex_code) as ex_code -- 电子联行号
    ,nvl(n.ex_account, o.ex_account) as ex_account -- 大额支付系统号
    ,nvl(n.swift_code, o.swift_code) as swift_code -- swift电文代号
    ,nvl(n.ref_issuer_id, o.ref_issuer_id) as ref_issuer_id -- 发行人/担保人ID
    ,nvl(n.issuer_name, o.issuer_name) as issuer_name -- 发行人/担保人中文名
    ,nvl(n.cfets_member_attr, o.cfets_member_attr) as cfets_member_attr -- 是否外汇会员
    ,nvl(n.master_short_cname, o.master_short_cname) as master_short_cname -- 主机构中文短名
    ,nvl(n.master_cfets_id, o.master_cfets_id) as master_cfets_id -- 主机构本币会员id
    ,nvl(n.master_cnty_seq, o.master_cnty_seq) as master_cnty_seq -- 主机构系统交易对手编号
    ,case when
            n.cptys_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cptys_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cptys_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_vs_cptys_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_vs_cptys where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cptys_id = n.cptys_id
where (
        o.cptys_id is null
    )
    or (
        n.cptys_id is null
    )
    or (
        o.aspclient_id <> n.aspclient_id
        or o.cptys_shortname <> n.cptys_shortname
        or o.cptys_name <> n.cptys_name
        or o.cptys_name2 <> n.cptys_name2
        or o.name_src <> n.name_src
        or o.key_src <> n.key_src
        or o.islink_src <> n.islink_src
        or o.lastmodified <> n.lastmodified
        or o.datasymbolconfig_id <> n.datasymbolconfig_id
        or o.label <> n.label
        or o.rating_level <> n.rating_level
        or o.field1 <> n.field1
        or o.field2 <> n.field2
        or o.field3 <> n.field3
        or o.counterparty_ename <> n.counterparty_ename
        or o.counterparty_short_ename <> n.counterparty_short_ename
        or o.contact_name <> n.contact_name
        or o.telephone <> n.telephone
        or o.fax <> n.fax
        or o.is_issuer <> n.is_issuer
        or o.is_bank <> n.is_bank
        or o.is_guarantee <> n.is_guarantee
        or o.is_custody <> n.is_custody
        or o.customer_type_code <> n.customer_type_code
        or o.customer_type_name <> n.customer_type_name
        or o.parent <> n.parent
        or o.ex_code <> n.ex_code
        or o.ex_account <> n.ex_account
        or o.swift_code <> n.swift_code
        or o.ref_issuer_id <> n.ref_issuer_id
        or o.issuer_name <> n.issuer_name
        or o.cfets_member_attr <> n.cfets_member_attr
        or o.master_short_cname <> n.master_short_cname
        or o.master_cfets_id <> n.master_cfets_id
        or o.master_cnty_seq <> n.master_cnty_seq
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_cptys_cl(
            cptys_id -- 交易对手ID
            ,aspclient_id -- 部门ID
            ,cptys_shortname -- 交易对手简称
            ,cptys_name -- 交易对手全称
            ,cptys_name2 -- 交易对手名称2
            ,name_src -- 电子证书名称
            ,key_src -- 数字证书号
            ,islink_src -- 是否连接电子证书
            ,lastmodified -- 最后修改时间
            ,datasymbolconfig_id -- 数据源配置ID
            ,label -- 其他系统代号
            ,rating_level -- 内部评级
            ,field1 -- 扩展字段1
            ,field2 -- 扩展字段2
            ,field3 -- 扩展字段3
            ,counterparty_ename -- 交易对手英文名称
            ,counterparty_short_ename -- 交易对手英文简称
            ,contact_name -- 联系人姓名
            ,telephone -- 电话
            ,fax -- 传真
            ,is_issuer -- 是否是发行人
            ,is_bank -- 是否是金融机构
            ,is_guarantee -- 是否是担保人
            ,is_custody -- 是否是托管机构
            ,customer_type_code -- 行业类别code
            ,customer_type_name -- 行业类别name
            ,parent -- 母公司id
            ,ex_code -- 电子联行号
            ,ex_account -- 大额支付系统号
            ,swift_code -- swift电文代号
            ,ref_issuer_id -- 发行人/担保人ID
            ,issuer_name -- 发行人/担保人中文名
            ,cfets_member_attr -- 是否外汇会员
            ,master_short_cname -- 主机构中文短名
            ,master_cfets_id -- 主机构本币会员id
            ,master_cnty_seq -- 主机构系统交易对手编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_cptys_op(
            cptys_id -- 交易对手ID
            ,aspclient_id -- 部门ID
            ,cptys_shortname -- 交易对手简称
            ,cptys_name -- 交易对手全称
            ,cptys_name2 -- 交易对手名称2
            ,name_src -- 电子证书名称
            ,key_src -- 数字证书号
            ,islink_src -- 是否连接电子证书
            ,lastmodified -- 最后修改时间
            ,datasymbolconfig_id -- 数据源配置ID
            ,label -- 其他系统代号
            ,rating_level -- 内部评级
            ,field1 -- 扩展字段1
            ,field2 -- 扩展字段2
            ,field3 -- 扩展字段3
            ,counterparty_ename -- 交易对手英文名称
            ,counterparty_short_ename -- 交易对手英文简称
            ,contact_name -- 联系人姓名
            ,telephone -- 电话
            ,fax -- 传真
            ,is_issuer -- 是否是发行人
            ,is_bank -- 是否是金融机构
            ,is_guarantee -- 是否是担保人
            ,is_custody -- 是否是托管机构
            ,customer_type_code -- 行业类别code
            ,customer_type_name -- 行业类别name
            ,parent -- 母公司id
            ,ex_code -- 电子联行号
            ,ex_account -- 大额支付系统号
            ,swift_code -- swift电文代号
            ,ref_issuer_id -- 发行人/担保人ID
            ,issuer_name -- 发行人/担保人中文名
            ,cfets_member_attr -- 是否外汇会员
            ,master_short_cname -- 主机构中文短名
            ,master_cfets_id -- 主机构本币会员id
            ,master_cnty_seq -- 主机构系统交易对手编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cptys_id -- 交易对手ID
    ,o.aspclient_id -- 部门ID
    ,o.cptys_shortname -- 交易对手简称
    ,o.cptys_name -- 交易对手全称
    ,o.cptys_name2 -- 交易对手名称2
    ,o.name_src -- 电子证书名称
    ,o.key_src -- 数字证书号
    ,o.islink_src -- 是否连接电子证书
    ,o.lastmodified -- 最后修改时间
    ,o.datasymbolconfig_id -- 数据源配置ID
    ,o.label -- 其他系统代号
    ,o.rating_level -- 内部评级
    ,o.field1 -- 扩展字段1
    ,o.field2 -- 扩展字段2
    ,o.field3 -- 扩展字段3
    ,o.counterparty_ename -- 交易对手英文名称
    ,o.counterparty_short_ename -- 交易对手英文简称
    ,o.contact_name -- 联系人姓名
    ,o.telephone -- 电话
    ,o.fax -- 传真
    ,o.is_issuer -- 是否是发行人
    ,o.is_bank -- 是否是金融机构
    ,o.is_guarantee -- 是否是担保人
    ,o.is_custody -- 是否是托管机构
    ,o.customer_type_code -- 行业类别code
    ,o.customer_type_name -- 行业类别name
    ,o.parent -- 母公司id
    ,o.ex_code -- 电子联行号
    ,o.ex_account -- 大额支付系统号
    ,o.swift_code -- swift电文代号
    ,o.ref_issuer_id -- 发行人/担保人ID
    ,o.issuer_name -- 发行人/担保人中文名
    ,o.cfets_member_attr -- 是否外汇会员
    ,o.master_short_cname -- 主机构中文短名
    ,o.master_cfets_id -- 主机构本币会员id
    ,o.master_cnty_seq -- 主机构系统交易对手编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_vs_cptys_bk o
    left join ${iol_schema}.ctms_tbs_vs_cptys_op n
        on
            o.cptys_id = n.cptys_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_vs_cptys_cl d
        on
            o.cptys_id = d.cptys_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_tbs_vs_cptys;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_vs_cptys exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_vs_cptys_cl;
alter table ${iol_schema}.ctms_tbs_vs_cptys exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_vs_cptys_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_vs_cptys to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_cptys_op purge;
drop table ${iol_schema}.ctms_tbs_vs_cptys_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_vs_cptys_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_vs_cptys',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
