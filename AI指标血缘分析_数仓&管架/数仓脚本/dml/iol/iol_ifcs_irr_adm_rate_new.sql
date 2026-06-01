/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifcs_irr_adm_rate_new
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
create table ${iol_schema}.ifcs_irr_adm_rate_new_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifcs_irr_adm_rate_new
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifcs_irr_adm_rate_new_op purge;
drop table ${iol_schema}.ifcs_irr_adm_rate_new_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_irr_adm_rate_new_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifcs_irr_adm_rate_new where 0=1;

create table ${iol_schema}.ifcs_irr_adm_rate_new_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifcs_irr_adm_rate_new where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifcs_irr_adm_rate_new_cl(
            data_dt -- 数据日期
            ,org_num -- 机构号
            ,business_typ -- 业务大类1：存款2：资金3：贷款4：转贴现
            ,acct_typ -- 业务细类
            ,corp_scale -- 企业规模1：大型2：中型3：小型4：微型仅301-单位普通贷款需要提供
            ,rate_float_range -- 利率浮动区：间指实际利率与基准利率的比值落在那个区间,仅存、贷款业务提供（不包括贴现、转贴现）
            ,amount -- 发生额：非活期性质的业务提供发生额（(贷款、转贴、定期性质存款、定期性质同业)）
            ,balance -- 余额:活期性质的业务提供的余额（活期、协定、通知、其他活期性质）
            ,orig_term_code -- 原始期限代码
            ,int_rate_typ -- 利率类型,仅 ”贷款“ 业务提供
            ,fina_code -- 金融机构类型代码,仅资金业务提供
            ,curr_cd -- 币种
            ,amt_typ -- 大小额存款标识,仅外币”存款“提供
            ,max_int_rat -- 最高利率
            ,min_int_rat -- 最低利率
            ,ave_int_rat -- 加权利率
            ,max_amt -- 最高利率发生额或者余额
            ,min_amt -- 最低利率发生额或者余额
            ,tranway_flg -- 网上网下交易标志1网上2网下,已经停用
            ,cust_typ -- 客户类型1对公2对私
            ,agreement_typ -- 协议存款人类别,仅”协议存款“需要提供
            ,srcsys_cd -- 源系统代码,数据源的业务系统代码。由银行根据自己系统情况自行编制
            ,fac_typ -- 单户授信分类
            ,operate_cust_type -- 经营性贷款主体类型
            ,float_type -- 浮动利率参考类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifcs_irr_adm_rate_new_op(
            data_dt -- 数据日期
            ,org_num -- 机构号
            ,business_typ -- 业务大类1：存款2：资金3：贷款4：转贴现
            ,acct_typ -- 业务细类
            ,corp_scale -- 企业规模1：大型2：中型3：小型4：微型仅301-单位普通贷款需要提供
            ,rate_float_range -- 利率浮动区：间指实际利率与基准利率的比值落在那个区间,仅存、贷款业务提供（不包括贴现、转贴现）
            ,amount -- 发生额：非活期性质的业务提供发生额（(贷款、转贴、定期性质存款、定期性质同业)）
            ,balance -- 余额:活期性质的业务提供的余额（活期、协定、通知、其他活期性质）
            ,orig_term_code -- 原始期限代码
            ,int_rate_typ -- 利率类型,仅 ”贷款“ 业务提供
            ,fina_code -- 金融机构类型代码,仅资金业务提供
            ,curr_cd -- 币种
            ,amt_typ -- 大小额存款标识,仅外币”存款“提供
            ,max_int_rat -- 最高利率
            ,min_int_rat -- 最低利率
            ,ave_int_rat -- 加权利率
            ,max_amt -- 最高利率发生额或者余额
            ,min_amt -- 最低利率发生额或者余额
            ,tranway_flg -- 网上网下交易标志1网上2网下,已经停用
            ,cust_typ -- 客户类型1对公2对私
            ,agreement_typ -- 协议存款人类别,仅”协议存款“需要提供
            ,srcsys_cd -- 源系统代码,数据源的业务系统代码。由银行根据自己系统情况自行编制
            ,fac_typ -- 单户授信分类
            ,operate_cust_type -- 经营性贷款主体类型
            ,float_type -- 浮动利率参考类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.data_dt, o.data_dt) as data_dt -- 数据日期
    ,nvl(n.org_num, o.org_num) as org_num -- 机构号
    ,nvl(n.business_typ, o.business_typ) as business_typ -- 业务大类1：存款2：资金3：贷款4：转贴现
    ,nvl(n.acct_typ, o.acct_typ) as acct_typ -- 业务细类
    ,nvl(n.corp_scale, o.corp_scale) as corp_scale -- 企业规模1：大型2：中型3：小型4：微型仅301-单位普通贷款需要提供
    ,nvl(n.rate_float_range, o.rate_float_range) as rate_float_range -- 利率浮动区：间指实际利率与基准利率的比值落在那个区间,仅存、贷款业务提供（不包括贴现、转贴现）
    ,nvl(n.amount, o.amount) as amount -- 发生额：非活期性质的业务提供发生额（(贷款、转贴、定期性质存款、定期性质同业)）
    ,nvl(n.balance, o.balance) as balance -- 余额:活期性质的业务提供的余额（活期、协定、通知、其他活期性质）
    ,nvl(n.orig_term_code, o.orig_term_code) as orig_term_code -- 原始期限代码
    ,nvl(n.int_rate_typ, o.int_rate_typ) as int_rate_typ -- 利率类型,仅 ”贷款“ 业务提供
    ,nvl(n.fina_code, o.fina_code) as fina_code -- 金融机构类型代码,仅资金业务提供
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种
    ,nvl(n.amt_typ, o.amt_typ) as amt_typ -- 大小额存款标识,仅外币”存款“提供
    ,nvl(n.max_int_rat, o.max_int_rat) as max_int_rat -- 最高利率
    ,nvl(n.min_int_rat, o.min_int_rat) as min_int_rat -- 最低利率
    ,nvl(n.ave_int_rat, o.ave_int_rat) as ave_int_rat -- 加权利率
    ,nvl(n.max_amt, o.max_amt) as max_amt -- 最高利率发生额或者余额
    ,nvl(n.min_amt, o.min_amt) as min_amt -- 最低利率发生额或者余额
    ,nvl(n.tranway_flg, o.tranway_flg) as tranway_flg -- 网上网下交易标志1网上2网下,已经停用
    ,nvl(n.cust_typ, o.cust_typ) as cust_typ -- 客户类型1对公2对私
    ,nvl(n.agreement_typ, o.agreement_typ) as agreement_typ -- 协议存款人类别,仅”协议存款“需要提供
    ,nvl(n.srcsys_cd, o.srcsys_cd) as srcsys_cd -- 源系统代码,数据源的业务系统代码。由银行根据自己系统情况自行编制
    ,nvl(n.fac_typ, o.fac_typ) as fac_typ -- 单户授信分类
    ,nvl(n.operate_cust_type, o.operate_cust_type) as operate_cust_type -- 经营性贷款主体类型
    ,nvl(n.float_type, o.float_type) as float_type -- 浮动利率参考类型
    ,case when
            n.data_dt is null
            and n.org_num is null
            and n.acct_typ is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.data_dt is null
            and n.org_num is null
            and n.acct_typ is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.data_dt is null
            and n.org_num is null
            and n.acct_typ is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifcs_irr_adm_rate_new_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifcs_irr_adm_rate_new where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.data_dt = n.data_dt
            and o.org_num = n.org_num
            and o.acct_typ = n.acct_typ
where (
        o.data_dt is null
        and o.org_num is null
        and o.acct_typ is null
    )
    or (
        n.data_dt is null
        and n.org_num is null
        and n.acct_typ is null
    )
    or (
        o.business_typ <> n.business_typ
        or o.corp_scale <> n.corp_scale
        or o.rate_float_range <> n.rate_float_range
        or o.amount <> n.amount
        or o.balance <> n.balance
        or o.orig_term_code <> n.orig_term_code
        or o.int_rate_typ <> n.int_rate_typ
        or o.fina_code <> n.fina_code
        or o.curr_cd <> n.curr_cd
        or o.amt_typ <> n.amt_typ
        or o.max_int_rat <> n.max_int_rat
        or o.min_int_rat <> n.min_int_rat
        or o.ave_int_rat <> n.ave_int_rat
        or o.max_amt <> n.max_amt
        or o.min_amt <> n.min_amt
        or o.tranway_flg <> n.tranway_flg
        or o.cust_typ <> n.cust_typ
        or o.agreement_typ <> n.agreement_typ
        or o.srcsys_cd <> n.srcsys_cd
        or o.fac_typ <> n.fac_typ
        or o.operate_cust_type <> n.operate_cust_type
        or o.float_type <> n.float_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifcs_irr_adm_rate_new_cl(
            data_dt -- 数据日期
            ,org_num -- 机构号
            ,business_typ -- 业务大类1：存款2：资金3：贷款4：转贴现
            ,acct_typ -- 业务细类
            ,corp_scale -- 企业规模1：大型2：中型3：小型4：微型仅301-单位普通贷款需要提供
            ,rate_float_range -- 利率浮动区：间指实际利率与基准利率的比值落在那个区间,仅存、贷款业务提供（不包括贴现、转贴现）
            ,amount -- 发生额：非活期性质的业务提供发生额（(贷款、转贴、定期性质存款、定期性质同业)）
            ,balance -- 余额:活期性质的业务提供的余额（活期、协定、通知、其他活期性质）
            ,orig_term_code -- 原始期限代码
            ,int_rate_typ -- 利率类型,仅 ”贷款“ 业务提供
            ,fina_code -- 金融机构类型代码,仅资金业务提供
            ,curr_cd -- 币种
            ,amt_typ -- 大小额存款标识,仅外币”存款“提供
            ,max_int_rat -- 最高利率
            ,min_int_rat -- 最低利率
            ,ave_int_rat -- 加权利率
            ,max_amt -- 最高利率发生额或者余额
            ,min_amt -- 最低利率发生额或者余额
            ,tranway_flg -- 网上网下交易标志1网上2网下,已经停用
            ,cust_typ -- 客户类型1对公2对私
            ,agreement_typ -- 协议存款人类别,仅”协议存款“需要提供
            ,srcsys_cd -- 源系统代码,数据源的业务系统代码。由银行根据自己系统情况自行编制
            ,fac_typ -- 单户授信分类
            ,operate_cust_type -- 经营性贷款主体类型
            ,float_type -- 浮动利率参考类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifcs_irr_adm_rate_new_op(
            data_dt -- 数据日期
            ,org_num -- 机构号
            ,business_typ -- 业务大类1：存款2：资金3：贷款4：转贴现
            ,acct_typ -- 业务细类
            ,corp_scale -- 企业规模1：大型2：中型3：小型4：微型仅301-单位普通贷款需要提供
            ,rate_float_range -- 利率浮动区：间指实际利率与基准利率的比值落在那个区间,仅存、贷款业务提供（不包括贴现、转贴现）
            ,amount -- 发生额：非活期性质的业务提供发生额（(贷款、转贴、定期性质存款、定期性质同业)）
            ,balance -- 余额:活期性质的业务提供的余额（活期、协定、通知、其他活期性质）
            ,orig_term_code -- 原始期限代码
            ,int_rate_typ -- 利率类型,仅 ”贷款“ 业务提供
            ,fina_code -- 金融机构类型代码,仅资金业务提供
            ,curr_cd -- 币种
            ,amt_typ -- 大小额存款标识,仅外币”存款“提供
            ,max_int_rat -- 最高利率
            ,min_int_rat -- 最低利率
            ,ave_int_rat -- 加权利率
            ,max_amt -- 最高利率发生额或者余额
            ,min_amt -- 最低利率发生额或者余额
            ,tranway_flg -- 网上网下交易标志1网上2网下,已经停用
            ,cust_typ -- 客户类型1对公2对私
            ,agreement_typ -- 协议存款人类别,仅”协议存款“需要提供
            ,srcsys_cd -- 源系统代码,数据源的业务系统代码。由银行根据自己系统情况自行编制
            ,fac_typ -- 单户授信分类
            ,operate_cust_type -- 经营性贷款主体类型
            ,float_type -- 浮动利率参考类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.data_dt -- 数据日期
    ,o.org_num -- 机构号
    ,o.business_typ -- 业务大类1：存款2：资金3：贷款4：转贴现
    ,o.acct_typ -- 业务细类
    ,o.corp_scale -- 企业规模1：大型2：中型3：小型4：微型仅301-单位普通贷款需要提供
    ,o.rate_float_range -- 利率浮动区：间指实际利率与基准利率的比值落在那个区间,仅存、贷款业务提供（不包括贴现、转贴现）
    ,o.amount -- 发生额：非活期性质的业务提供发生额（(贷款、转贴、定期性质存款、定期性质同业)）
    ,o.balance -- 余额:活期性质的业务提供的余额（活期、协定、通知、其他活期性质）
    ,o.orig_term_code -- 原始期限代码
    ,o.int_rate_typ -- 利率类型,仅 ”贷款“ 业务提供
    ,o.fina_code -- 金融机构类型代码,仅资金业务提供
    ,o.curr_cd -- 币种
    ,o.amt_typ -- 大小额存款标识,仅外币”存款“提供
    ,o.max_int_rat -- 最高利率
    ,o.min_int_rat -- 最低利率
    ,o.ave_int_rat -- 加权利率
    ,o.max_amt -- 最高利率发生额或者余额
    ,o.min_amt -- 最低利率发生额或者余额
    ,o.tranway_flg -- 网上网下交易标志1网上2网下,已经停用
    ,o.cust_typ -- 客户类型1对公2对私
    ,o.agreement_typ -- 协议存款人类别,仅”协议存款“需要提供
    ,o.srcsys_cd -- 源系统代码,数据源的业务系统代码。由银行根据自己系统情况自行编制
    ,o.fac_typ -- 单户授信分类
    ,o.operate_cust_type -- 经营性贷款主体类型
    ,o.float_type -- 浮动利率参考类型
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
from ${iol_schema}.ifcs_irr_adm_rate_new_bk o
    left join ${iol_schema}.ifcs_irr_adm_rate_new_op n
        on
            o.data_dt = n.data_dt
            and o.org_num = n.org_num
            and o.acct_typ = n.acct_typ
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifcs_irr_adm_rate_new_cl d
        on
            o.data_dt = d.data_dt
            and o.org_num = d.org_num
            and o.acct_typ = d.acct_typ
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ifcs_irr_adm_rate_new;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ifcs_irr_adm_rate_new') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ifcs_irr_adm_rate_new drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ifcs_irr_adm_rate_new add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ifcs_irr_adm_rate_new exchange partition p_${batch_date} with table ${iol_schema}.ifcs_irr_adm_rate_new_cl;
alter table ${iol_schema}.ifcs_irr_adm_rate_new exchange partition p_20991231 with table ${iol_schema}.ifcs_irr_adm_rate_new_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifcs_irr_adm_rate_new to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifcs_irr_adm_rate_new_op purge;
drop table ${iol_schema}.ifcs_irr_adm_rate_new_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifcs_irr_adm_rate_new_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifcs_irr_adm_rate_new',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
