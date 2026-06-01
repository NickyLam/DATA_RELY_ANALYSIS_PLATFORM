/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_asharecapitalization
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
create table ${iol_schema}.wind_asharecapitalization_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_asharecapitalization;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_asharecapitalization_op purge;
drop table ${iol_schema}.wind_asharecapitalization_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_asharecapitalization_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_asharecapitalization where 0=1;

create table ${iol_schema}.wind_asharecapitalization_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_asharecapitalization where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_asharecapitalization_cl(
            object_id -- 对象id
            ,wind_code -- wind代码
            ,s_info_windcode -- wind代码
            ,change_dt -- 变动日期
            ,tot_shr -- 总股本(万股)
            ,float_shr -- 流通股(万股)
            ,float_a_shr -- 流通a股(万股)
            ,float_b_shr -- 流通b股(万股)
            ,float_h_shr -- 流通h股(万股)
            ,float_overseas_shr -- 境外流通股(万股)
            ,restricted_a_shr -- 限售a股(万股)
            ,s_share_rtd_state -- 限售股份(国家持股)(万股)
            ,s_share_rtd_statejur -- 限售股份(国有法人持股)(万股)
            ,s_share_rtd_subotherdomes -- 限售股份(其他内资持股)(万股)
            ,s_share_rtd_domesjur -- 限售股份(境内法人持股)(万股)
            ,s_share_rtd_inst -- 限售股份(机构配售股份)(万股)
            ,s_share_rtd_domesnp -- 限售股份(境内自然人持股)(万股)
            ,s_share_rtd_senmanager -- 限售股份(高管持股)(万股)
            ,s_share_rtd_subfrgn -- 限售股份(外资持股)(万股)
            ,s_share_rtd_frgnjur -- 限售股份(境外法人持股)(万股)
            ,s_share_rtd_frgnnp -- 限售股份(境外自然人持股)(万股)
            ,restricted_b_shr -- 限售b股
            ,other_restricted_shr -- 其他限售股
            ,non_tradable_shr -- 非流通股
            ,s_share_ntrd_state_pct -- 国有股(万股)
            ,s_share_ntrd_state -- 国家股(万股)
            ,s_share_ntrd_statjur -- 国有法人股(万股)
            ,s_share_ntrd_subdomesjur -- 境内法人股(万股)
            ,s_share_ntrd_domesinitor -- 境内发起人股(万股)
            ,s_share_ntrd_ipojuris -- 募集法人股(万股)
            ,s_share_ntrd_genjuris -- 一般法人股(万股)
            ,s_share_ntrd_strtinvestor -- 战略投资者持股(万股)
            ,s_share_ntrd_fundbal -- 基金持股(万股)
            ,s_share_ntrd_ipoinip -- 自然人股(万股)
            ,s_share_ntrd_trfnshare -- 转配股(万股)
            ,s_share_ntrd_snormnger -- 高管股(万股)
            ,s_share_ntrd_insderemp -- 内部职工股(万股)
            ,s_share_ntrd_prfshare -- 优先股(万股)
            ,s_share_ntrd_nonlstfrgn -- 非上市外资股(万股)
            ,s_share_ntrd_staq -- staq股(万股)
            ,s_share_ntrd_net -- net股(万股)
            ,s_share_changereason -- 股本变动原因
            ,ann_dt -- 公告日期
            ,change_dt1 -- 变动日期1
            ,cur_sign -- 最新标志
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_asharecapitalization_op(
            object_id -- 对象id
            ,wind_code -- wind代码
            ,s_info_windcode -- wind代码
            ,change_dt -- 变动日期
            ,tot_shr -- 总股本(万股)
            ,float_shr -- 流通股(万股)
            ,float_a_shr -- 流通a股(万股)
            ,float_b_shr -- 流通b股(万股)
            ,float_h_shr -- 流通h股(万股)
            ,float_overseas_shr -- 境外流通股(万股)
            ,restricted_a_shr -- 限售a股(万股)
            ,s_share_rtd_state -- 限售股份(国家持股)(万股)
            ,s_share_rtd_statejur -- 限售股份(国有法人持股)(万股)
            ,s_share_rtd_subotherdomes -- 限售股份(其他内资持股)(万股)
            ,s_share_rtd_domesjur -- 限售股份(境内法人持股)(万股)
            ,s_share_rtd_inst -- 限售股份(机构配售股份)(万股)
            ,s_share_rtd_domesnp -- 限售股份(境内自然人持股)(万股)
            ,s_share_rtd_senmanager -- 限售股份(高管持股)(万股)
            ,s_share_rtd_subfrgn -- 限售股份(外资持股)(万股)
            ,s_share_rtd_frgnjur -- 限售股份(境外法人持股)(万股)
            ,s_share_rtd_frgnnp -- 限售股份(境外自然人持股)(万股)
            ,restricted_b_shr -- 限售b股
            ,other_restricted_shr -- 其他限售股
            ,non_tradable_shr -- 非流通股
            ,s_share_ntrd_state_pct -- 国有股(万股)
            ,s_share_ntrd_state -- 国家股(万股)
            ,s_share_ntrd_statjur -- 国有法人股(万股)
            ,s_share_ntrd_subdomesjur -- 境内法人股(万股)
            ,s_share_ntrd_domesinitor -- 境内发起人股(万股)
            ,s_share_ntrd_ipojuris -- 募集法人股(万股)
            ,s_share_ntrd_genjuris -- 一般法人股(万股)
            ,s_share_ntrd_strtinvestor -- 战略投资者持股(万股)
            ,s_share_ntrd_fundbal -- 基金持股(万股)
            ,s_share_ntrd_ipoinip -- 自然人股(万股)
            ,s_share_ntrd_trfnshare -- 转配股(万股)
            ,s_share_ntrd_snormnger -- 高管股(万股)
            ,s_share_ntrd_insderemp -- 内部职工股(万股)
            ,s_share_ntrd_prfshare -- 优先股(万股)
            ,s_share_ntrd_nonlstfrgn -- 非上市外资股(万股)
            ,s_share_ntrd_staq -- staq股(万股)
            ,s_share_ntrd_net -- net股(万股)
            ,s_share_changereason -- 股本变动原因
            ,ann_dt -- 公告日期
            ,change_dt1 -- 变动日期1
            ,cur_sign -- 最新标志
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.object_id, o.object_id) as object_id -- 对象id
    ,nvl(n.wind_code, o.wind_code) as wind_code -- wind代码
    ,nvl(n.s_info_windcode, o.s_info_windcode) as s_info_windcode -- wind代码
    ,nvl(n.change_dt, o.change_dt) as change_dt -- 变动日期
    ,nvl(n.tot_shr, o.tot_shr) as tot_shr -- 总股本(万股)
    ,nvl(n.float_shr, o.float_shr) as float_shr -- 流通股(万股)
    ,nvl(n.float_a_shr, o.float_a_shr) as float_a_shr -- 流通a股(万股)
    ,nvl(n.float_b_shr, o.float_b_shr) as float_b_shr -- 流通b股(万股)
    ,nvl(n.float_h_shr, o.float_h_shr) as float_h_shr -- 流通h股(万股)
    ,nvl(n.float_overseas_shr, o.float_overseas_shr) as float_overseas_shr -- 境外流通股(万股)
    ,nvl(n.restricted_a_shr, o.restricted_a_shr) as restricted_a_shr -- 限售a股(万股)
    ,nvl(n.s_share_rtd_state, o.s_share_rtd_state) as s_share_rtd_state -- 限售股份(国家持股)(万股)
    ,nvl(n.s_share_rtd_statejur, o.s_share_rtd_statejur) as s_share_rtd_statejur -- 限售股份(国有法人持股)(万股)
    ,nvl(n.s_share_rtd_subotherdomes, o.s_share_rtd_subotherdomes) as s_share_rtd_subotherdomes -- 限售股份(其他内资持股)(万股)
    ,nvl(n.s_share_rtd_domesjur, o.s_share_rtd_domesjur) as s_share_rtd_domesjur -- 限售股份(境内法人持股)(万股)
    ,nvl(n.s_share_rtd_inst, o.s_share_rtd_inst) as s_share_rtd_inst -- 限售股份(机构配售股份)(万股)
    ,nvl(n.s_share_rtd_domesnp, o.s_share_rtd_domesnp) as s_share_rtd_domesnp -- 限售股份(境内自然人持股)(万股)
    ,nvl(n.s_share_rtd_senmanager, o.s_share_rtd_senmanager) as s_share_rtd_senmanager -- 限售股份(高管持股)(万股)
    ,nvl(n.s_share_rtd_subfrgn, o.s_share_rtd_subfrgn) as s_share_rtd_subfrgn -- 限售股份(外资持股)(万股)
    ,nvl(n.s_share_rtd_frgnjur, o.s_share_rtd_frgnjur) as s_share_rtd_frgnjur -- 限售股份(境外法人持股)(万股)
    ,nvl(n.s_share_rtd_frgnnp, o.s_share_rtd_frgnnp) as s_share_rtd_frgnnp -- 限售股份(境外自然人持股)(万股)
    ,nvl(n.restricted_b_shr, o.restricted_b_shr) as restricted_b_shr -- 限售b股
    ,nvl(n.other_restricted_shr, o.other_restricted_shr) as other_restricted_shr -- 其他限售股
    ,nvl(n.non_tradable_shr, o.non_tradable_shr) as non_tradable_shr -- 非流通股
    ,nvl(n.s_share_ntrd_state_pct, o.s_share_ntrd_state_pct) as s_share_ntrd_state_pct -- 国有股(万股)
    ,nvl(n.s_share_ntrd_state, o.s_share_ntrd_state) as s_share_ntrd_state -- 国家股(万股)
    ,nvl(n.s_share_ntrd_statjur, o.s_share_ntrd_statjur) as s_share_ntrd_statjur -- 国有法人股(万股)
    ,nvl(n.s_share_ntrd_subdomesjur, o.s_share_ntrd_subdomesjur) as s_share_ntrd_subdomesjur -- 境内法人股(万股)
    ,nvl(n.s_share_ntrd_domesinitor, o.s_share_ntrd_domesinitor) as s_share_ntrd_domesinitor -- 境内发起人股(万股)
    ,nvl(n.s_share_ntrd_ipojuris, o.s_share_ntrd_ipojuris) as s_share_ntrd_ipojuris -- 募集法人股(万股)
    ,nvl(n.s_share_ntrd_genjuris, o.s_share_ntrd_genjuris) as s_share_ntrd_genjuris -- 一般法人股(万股)
    ,nvl(n.s_share_ntrd_strtinvestor, o.s_share_ntrd_strtinvestor) as s_share_ntrd_strtinvestor -- 战略投资者持股(万股)
    ,nvl(n.s_share_ntrd_fundbal, o.s_share_ntrd_fundbal) as s_share_ntrd_fundbal -- 基金持股(万股)
    ,nvl(n.s_share_ntrd_ipoinip, o.s_share_ntrd_ipoinip) as s_share_ntrd_ipoinip -- 自然人股(万股)
    ,nvl(n.s_share_ntrd_trfnshare, o.s_share_ntrd_trfnshare) as s_share_ntrd_trfnshare -- 转配股(万股)
    ,nvl(n.s_share_ntrd_snormnger, o.s_share_ntrd_snormnger) as s_share_ntrd_snormnger -- 高管股(万股)
    ,nvl(n.s_share_ntrd_insderemp, o.s_share_ntrd_insderemp) as s_share_ntrd_insderemp -- 内部职工股(万股)
    ,nvl(n.s_share_ntrd_prfshare, o.s_share_ntrd_prfshare) as s_share_ntrd_prfshare -- 优先股(万股)
    ,nvl(n.s_share_ntrd_nonlstfrgn, o.s_share_ntrd_nonlstfrgn) as s_share_ntrd_nonlstfrgn -- 非上市外资股(万股)
    ,nvl(n.s_share_ntrd_staq, o.s_share_ntrd_staq) as s_share_ntrd_staq -- staq股(万股)
    ,nvl(n.s_share_ntrd_net, o.s_share_ntrd_net) as s_share_ntrd_net -- net股(万股)
    ,nvl(n.s_share_changereason, o.s_share_changereason) as s_share_changereason -- 股本变动原因
    ,nvl(n.ann_dt, o.ann_dt) as ann_dt -- 公告日期
    ,nvl(n.change_dt1, o.change_dt1) as change_dt1 -- 变动日期1
    ,nvl(n.cur_sign, o.cur_sign) as cur_sign -- 最新标志
    ,nvl(n.opdate, o.opdate) as opdate -- 
    ,nvl(n.opmode, o.opmode) as opmode -- 
    ,case when
            n.object_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.object_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.object_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.wind_asharecapitalization_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.wind_asharecapitalization where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.object_id = n.object_id
where (
        o.object_id is null
    )
    or (
        n.object_id is null
    )
    or (
        o.wind_code <> n.wind_code
        or o.s_info_windcode <> n.s_info_windcode
        or o.change_dt <> n.change_dt
        or o.tot_shr <> n.tot_shr
        or o.float_shr <> n.float_shr
        or o.float_a_shr <> n.float_a_shr
        or o.float_b_shr <> n.float_b_shr
        or o.float_h_shr <> n.float_h_shr
        or o.float_overseas_shr <> n.float_overseas_shr
        or o.restricted_a_shr <> n.restricted_a_shr
        or o.s_share_rtd_state <> n.s_share_rtd_state
        or o.s_share_rtd_statejur <> n.s_share_rtd_statejur
        or o.s_share_rtd_subotherdomes <> n.s_share_rtd_subotherdomes
        or o.s_share_rtd_domesjur <> n.s_share_rtd_domesjur
        or o.s_share_rtd_inst <> n.s_share_rtd_inst
        or o.s_share_rtd_domesnp <> n.s_share_rtd_domesnp
        or o.s_share_rtd_senmanager <> n.s_share_rtd_senmanager
        or o.s_share_rtd_subfrgn <> n.s_share_rtd_subfrgn
        or o.s_share_rtd_frgnjur <> n.s_share_rtd_frgnjur
        or o.s_share_rtd_frgnnp <> n.s_share_rtd_frgnnp
        or o.restricted_b_shr <> n.restricted_b_shr
        or o.other_restricted_shr <> n.other_restricted_shr
        or o.non_tradable_shr <> n.non_tradable_shr
        or o.s_share_ntrd_state_pct <> n.s_share_ntrd_state_pct
        or o.s_share_ntrd_state <> n.s_share_ntrd_state
        or o.s_share_ntrd_statjur <> n.s_share_ntrd_statjur
        or o.s_share_ntrd_subdomesjur <> n.s_share_ntrd_subdomesjur
        or o.s_share_ntrd_domesinitor <> n.s_share_ntrd_domesinitor
        or o.s_share_ntrd_ipojuris <> n.s_share_ntrd_ipojuris
        or o.s_share_ntrd_genjuris <> n.s_share_ntrd_genjuris
        or o.s_share_ntrd_strtinvestor <> n.s_share_ntrd_strtinvestor
        or o.s_share_ntrd_fundbal <> n.s_share_ntrd_fundbal
        or o.s_share_ntrd_ipoinip <> n.s_share_ntrd_ipoinip
        or o.s_share_ntrd_trfnshare <> n.s_share_ntrd_trfnshare
        or o.s_share_ntrd_snormnger <> n.s_share_ntrd_snormnger
        or o.s_share_ntrd_insderemp <> n.s_share_ntrd_insderemp
        or o.s_share_ntrd_prfshare <> n.s_share_ntrd_prfshare
        or o.s_share_ntrd_nonlstfrgn <> n.s_share_ntrd_nonlstfrgn
        or o.s_share_ntrd_staq <> n.s_share_ntrd_staq
        or o.s_share_ntrd_net <> n.s_share_ntrd_net
        or o.s_share_changereason <> n.s_share_changereason
        or o.ann_dt <> n.ann_dt
        or o.change_dt1 <> n.change_dt1
        or o.cur_sign <> n.cur_sign
        or o.opdate <> n.opdate
        or o.opmode <> n.opmode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_asharecapitalization_cl(
            object_id -- 对象id
            ,wind_code -- wind代码
            ,s_info_windcode -- wind代码
            ,change_dt -- 变动日期
            ,tot_shr -- 总股本(万股)
            ,float_shr -- 流通股(万股)
            ,float_a_shr -- 流通a股(万股)
            ,float_b_shr -- 流通b股(万股)
            ,float_h_shr -- 流通h股(万股)
            ,float_overseas_shr -- 境外流通股(万股)
            ,restricted_a_shr -- 限售a股(万股)
            ,s_share_rtd_state -- 限售股份(国家持股)(万股)
            ,s_share_rtd_statejur -- 限售股份(国有法人持股)(万股)
            ,s_share_rtd_subotherdomes -- 限售股份(其他内资持股)(万股)
            ,s_share_rtd_domesjur -- 限售股份(境内法人持股)(万股)
            ,s_share_rtd_inst -- 限售股份(机构配售股份)(万股)
            ,s_share_rtd_domesnp -- 限售股份(境内自然人持股)(万股)
            ,s_share_rtd_senmanager -- 限售股份(高管持股)(万股)
            ,s_share_rtd_subfrgn -- 限售股份(外资持股)(万股)
            ,s_share_rtd_frgnjur -- 限售股份(境外法人持股)(万股)
            ,s_share_rtd_frgnnp -- 限售股份(境外自然人持股)(万股)
            ,restricted_b_shr -- 限售b股
            ,other_restricted_shr -- 其他限售股
            ,non_tradable_shr -- 非流通股
            ,s_share_ntrd_state_pct -- 国有股(万股)
            ,s_share_ntrd_state -- 国家股(万股)
            ,s_share_ntrd_statjur -- 国有法人股(万股)
            ,s_share_ntrd_subdomesjur -- 境内法人股(万股)
            ,s_share_ntrd_domesinitor -- 境内发起人股(万股)
            ,s_share_ntrd_ipojuris -- 募集法人股(万股)
            ,s_share_ntrd_genjuris -- 一般法人股(万股)
            ,s_share_ntrd_strtinvestor -- 战略投资者持股(万股)
            ,s_share_ntrd_fundbal -- 基金持股(万股)
            ,s_share_ntrd_ipoinip -- 自然人股(万股)
            ,s_share_ntrd_trfnshare -- 转配股(万股)
            ,s_share_ntrd_snormnger -- 高管股(万股)
            ,s_share_ntrd_insderemp -- 内部职工股(万股)
            ,s_share_ntrd_prfshare -- 优先股(万股)
            ,s_share_ntrd_nonlstfrgn -- 非上市外资股(万股)
            ,s_share_ntrd_staq -- staq股(万股)
            ,s_share_ntrd_net -- net股(万股)
            ,s_share_changereason -- 股本变动原因
            ,ann_dt -- 公告日期
            ,change_dt1 -- 变动日期1
            ,cur_sign -- 最新标志
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_asharecapitalization_op(
            object_id -- 对象id
            ,wind_code -- wind代码
            ,s_info_windcode -- wind代码
            ,change_dt -- 变动日期
            ,tot_shr -- 总股本(万股)
            ,float_shr -- 流通股(万股)
            ,float_a_shr -- 流通a股(万股)
            ,float_b_shr -- 流通b股(万股)
            ,float_h_shr -- 流通h股(万股)
            ,float_overseas_shr -- 境外流通股(万股)
            ,restricted_a_shr -- 限售a股(万股)
            ,s_share_rtd_state -- 限售股份(国家持股)(万股)
            ,s_share_rtd_statejur -- 限售股份(国有法人持股)(万股)
            ,s_share_rtd_subotherdomes -- 限售股份(其他内资持股)(万股)
            ,s_share_rtd_domesjur -- 限售股份(境内法人持股)(万股)
            ,s_share_rtd_inst -- 限售股份(机构配售股份)(万股)
            ,s_share_rtd_domesnp -- 限售股份(境内自然人持股)(万股)
            ,s_share_rtd_senmanager -- 限售股份(高管持股)(万股)
            ,s_share_rtd_subfrgn -- 限售股份(外资持股)(万股)
            ,s_share_rtd_frgnjur -- 限售股份(境外法人持股)(万股)
            ,s_share_rtd_frgnnp -- 限售股份(境外自然人持股)(万股)
            ,restricted_b_shr -- 限售b股
            ,other_restricted_shr -- 其他限售股
            ,non_tradable_shr -- 非流通股
            ,s_share_ntrd_state_pct -- 国有股(万股)
            ,s_share_ntrd_state -- 国家股(万股)
            ,s_share_ntrd_statjur -- 国有法人股(万股)
            ,s_share_ntrd_subdomesjur -- 境内法人股(万股)
            ,s_share_ntrd_domesinitor -- 境内发起人股(万股)
            ,s_share_ntrd_ipojuris -- 募集法人股(万股)
            ,s_share_ntrd_genjuris -- 一般法人股(万股)
            ,s_share_ntrd_strtinvestor -- 战略投资者持股(万股)
            ,s_share_ntrd_fundbal -- 基金持股(万股)
            ,s_share_ntrd_ipoinip -- 自然人股(万股)
            ,s_share_ntrd_trfnshare -- 转配股(万股)
            ,s_share_ntrd_snormnger -- 高管股(万股)
            ,s_share_ntrd_insderemp -- 内部职工股(万股)
            ,s_share_ntrd_prfshare -- 优先股(万股)
            ,s_share_ntrd_nonlstfrgn -- 非上市外资股(万股)
            ,s_share_ntrd_staq -- staq股(万股)
            ,s_share_ntrd_net -- net股(万股)
            ,s_share_changereason -- 股本变动原因
            ,ann_dt -- 公告日期
            ,change_dt1 -- 变动日期1
            ,cur_sign -- 最新标志
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.object_id -- 对象id
    ,o.wind_code -- wind代码
    ,o.s_info_windcode -- wind代码
    ,o.change_dt -- 变动日期
    ,o.tot_shr -- 总股本(万股)
    ,o.float_shr -- 流通股(万股)
    ,o.float_a_shr -- 流通a股(万股)
    ,o.float_b_shr -- 流通b股(万股)
    ,o.float_h_shr -- 流通h股(万股)
    ,o.float_overseas_shr -- 境外流通股(万股)
    ,o.restricted_a_shr -- 限售a股(万股)
    ,o.s_share_rtd_state -- 限售股份(国家持股)(万股)
    ,o.s_share_rtd_statejur -- 限售股份(国有法人持股)(万股)
    ,o.s_share_rtd_subotherdomes -- 限售股份(其他内资持股)(万股)
    ,o.s_share_rtd_domesjur -- 限售股份(境内法人持股)(万股)
    ,o.s_share_rtd_inst -- 限售股份(机构配售股份)(万股)
    ,o.s_share_rtd_domesnp -- 限售股份(境内自然人持股)(万股)
    ,o.s_share_rtd_senmanager -- 限售股份(高管持股)(万股)
    ,o.s_share_rtd_subfrgn -- 限售股份(外资持股)(万股)
    ,o.s_share_rtd_frgnjur -- 限售股份(境外法人持股)(万股)
    ,o.s_share_rtd_frgnnp -- 限售股份(境外自然人持股)(万股)
    ,o.restricted_b_shr -- 限售b股
    ,o.other_restricted_shr -- 其他限售股
    ,o.non_tradable_shr -- 非流通股
    ,o.s_share_ntrd_state_pct -- 国有股(万股)
    ,o.s_share_ntrd_state -- 国家股(万股)
    ,o.s_share_ntrd_statjur -- 国有法人股(万股)
    ,o.s_share_ntrd_subdomesjur -- 境内法人股(万股)
    ,o.s_share_ntrd_domesinitor -- 境内发起人股(万股)
    ,o.s_share_ntrd_ipojuris -- 募集法人股(万股)
    ,o.s_share_ntrd_genjuris -- 一般法人股(万股)
    ,o.s_share_ntrd_strtinvestor -- 战略投资者持股(万股)
    ,o.s_share_ntrd_fundbal -- 基金持股(万股)
    ,o.s_share_ntrd_ipoinip -- 自然人股(万股)
    ,o.s_share_ntrd_trfnshare -- 转配股(万股)
    ,o.s_share_ntrd_snormnger -- 高管股(万股)
    ,o.s_share_ntrd_insderemp -- 内部职工股(万股)
    ,o.s_share_ntrd_prfshare -- 优先股(万股)
    ,o.s_share_ntrd_nonlstfrgn -- 非上市外资股(万股)
    ,o.s_share_ntrd_staq -- staq股(万股)
    ,o.s_share_ntrd_net -- net股(万股)
    ,o.s_share_changereason -- 股本变动原因
    ,o.ann_dt -- 公告日期
    ,o.change_dt1 -- 变动日期1
    ,o.cur_sign -- 最新标志
    ,o.opdate -- 
    ,o.opmode -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_asharecapitalization_bk o
    left join ${iol_schema}.wind_asharecapitalization_op n
        on
            o.object_id = n.object_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.wind_asharecapitalization_cl d
        on
            o.object_id = d.object_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.wind_asharecapitalization;

-- 4.2 exchange partition
alter table ${iol_schema}.wind_asharecapitalization exchange partition p_19000101 with table ${iol_schema}.wind_asharecapitalization_cl;
alter table ${iol_schema}.wind_asharecapitalization exchange partition p_20991231 with table ${iol_schema}.wind_asharecapitalization_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_asharecapitalization to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_asharecapitalization_op purge;
drop table ${iol_schema}.wind_asharecapitalization_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_asharecapitalization_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_asharecapitalization',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
