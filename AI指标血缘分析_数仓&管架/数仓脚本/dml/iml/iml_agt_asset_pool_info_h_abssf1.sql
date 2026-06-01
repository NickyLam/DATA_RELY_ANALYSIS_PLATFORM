/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_asset_pool_info_h_abssf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_asset_pool_info_h add partition p_abssf1 values ('abssf1')(
        subpartition p_abssf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_abssf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_asset_pool_info_h_abssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_asset_pool_info_h partition for ('abssf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_asset_pool_info_h_abssf1_tm purge;
drop table ${iml_schema}.agt_asset_pool_info_h_abssf1_op purge;
drop table ${iml_schema}.agt_asset_pool_info_h_abssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_asset_pool_info_h_abssf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_pool_id -- 资产池编号
    ,asset_pool_name -- 资产池名称
    ,parent_asset_pool_id -- 父资产池编号
    ,asset_pool_type_cd -- 资产池类型代码
    ,asset_pool_char_cd -- 资产池性质代码
    ,asset_pool_status_cd -- 资产池状态代码
    ,pkg_flg -- 封包标志
    ,pkg_dt -- 封包日期
    ,tran_dt -- 转让日期
    ,recvbl_dt -- 收款日期
    ,pkg_day_asset_qtty -- 封包日资产数量
    ,pkg_day_asset_size -- 封包日资产规模
    ,tran_day_pric -- 转让日本金
    ,recvbl_day_pric -- 收款日本金
    ,actl_recvbl_amt -- 实际收款金额
    ,asset_pool_size -- 资产池规模
    ,unpkg_dt -- 解包日期
    ,end_type_cd -- 终结类型代码
    ,final_dt -- 终结日期
    ,add_pkg_asset_qtty -- 新增封包资产数量
    ,curr_cd -- 币种代码
    ,rgstrat_id -- 登记人编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_tm -- 登记时间
    ,asset_pool_acm_asset_size -- 资产池累计资产规模
    ,asset_pool_acm_asset_qtty -- 资产池累计资产数量
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_belong_org_id -- 收款账户所属机构编号
    ,return_coll_acct_name -- 回款归集账户名称
    ,return_coll_acct_num -- 回款归集账户账号
    ,coll_acct_belong_org_id -- 回款归集账户所属机构编号
    ,pkg_weight_surp_tenor -- 封包时加权剩余期限
    ,pkg_weight_avg_int_rat -- 封包时加权平均利率
    ,fee_provi_dt -- 费用计提日期
    ,asset_pool_realtm_size -- 资产池实时规模
    ,non_asset_flg -- 不良资产标志
    ,update_tm -- 更新时间
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_asset_pool_info_h partition for ('abssf1')
where 0=1
;

create table ${iml_schema}.agt_asset_pool_info_h_abssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_asset_pool_info_h partition for ('abssf1') where 0=1;

create table ${iml_schema}.agt_asset_pool_info_h_abssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_asset_pool_info_h partition for ('abssf1') where 0=1;

-- 3.1 get new data into table
-- abss_abs_asset_pool-
insert into ${iml_schema}.agt_asset_pool_info_h_abssf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_pool_id -- 资产池编号
    ,asset_pool_name -- 资产池名称
    ,parent_asset_pool_id -- 父资产池编号
    ,asset_pool_type_cd -- 资产池类型代码
    ,asset_pool_char_cd -- 资产池性质代码
    ,asset_pool_status_cd -- 资产池状态代码
    ,pkg_flg -- 封包标志
    ,pkg_dt -- 封包日期
    ,tran_dt -- 转让日期
    ,recvbl_dt -- 收款日期
    ,pkg_day_asset_qtty -- 封包日资产数量
    ,pkg_day_asset_size -- 封包日资产规模
    ,tran_day_pric -- 转让日本金
    ,recvbl_day_pric -- 收款日本金
    ,actl_recvbl_amt -- 实际收款金额
    ,asset_pool_size -- 资产池规模
    ,unpkg_dt -- 解包日期
    ,end_type_cd -- 终结类型代码
    ,final_dt -- 终结日期
    ,add_pkg_asset_qtty -- 新增封包资产数量
    ,curr_cd -- 币种代码
    ,rgstrat_id -- 登记人编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_tm -- 登记时间
    ,asset_pool_acm_asset_size -- 资产池累计资产规模
    ,asset_pool_acm_asset_qtty -- 资产池累计资产数量
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_belong_org_id -- 收款账户所属机构编号
    ,return_coll_acct_name -- 回款归集账户名称
    ,return_coll_acct_num -- 回款归集账户账号
    ,coll_acct_belong_org_id -- 回款归集账户所属机构编号
    ,pkg_weight_surp_tenor -- 封包时加权剩余期限
    ,pkg_weight_avg_int_rat -- 封包时加权平均利率
    ,fee_provi_dt -- 费用计提日期
    ,asset_pool_realtm_size -- 资产池实时规模
    ,non_asset_flg -- 不良资产标志
    ,update_tm -- 更新时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '225110'||P1.ASSETPOOLNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ASSETPOOLNO -- 资产池编号
    ,P1.ASSETPOOLNAME -- 资产池名称
    ,P1.PARENTASSETPOOLNO -- 父资产池编号
    ,P1.ASSETPOOLTYPE -- 资产池类型代码
    ,nvl(trim(P1.ASSETPOOLNATURE),'00') -- 资产池性质代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.ASSETPOOLSTATUS END -- 资产池状态代码
    ,P1.PACKETFLAG -- 封包标志
    ,${iml_schema}.dateformat_min(P1.PACKETDATE) -- 封包日期
    ,${iml_schema}.dateformat_min(P1.TRANSFERDATE) -- 转让日期
    ,${iml_schema}.dateformat_min(P1.COLLECTIONDATE) -- 收款日期
    ,P1.PACKETNUM -- 封包日资产数量
    ,P1.PACKETSIZE -- 封包日资产规模
    ,P1.TRANSFERPRIN -- 转让日本金
    ,P1.COLLECTIONPRIN -- 收款日本金
    ,P1.ACTUALCOLLECTION -- 实际收款金额
    ,P1.ASSETPOOLSIZE -- 资产池规模
    ,${iml_schema}.dateformat_min(P1.UNPACKETDATE) -- 解包日期
    ,nvl(trim(P1.FINISHTYPE),'00') -- 终结类型代码
    ,${iml_schema}.dateformat_max(P1.FINISHDATE) -- 终结日期
    ,P1.NEWPACKETASSETCOUNT -- 新增封包资产数量
    ,P1.CURRENCY -- 币种代码
    ,P1.INPUTUSERID -- 登记人编号
    ,P1.INPUTORGID -- 登记机构编号
    ,${iml_schema}.dateformat_min(P1.INPUTTIME) -- 登记时间
    ,P1.PACKETACCSIZE -- 资产池累计资产规模
    ,P1.PACKETACCNUM -- 资产池累计资产数量
    ,P1.COLLECTIONACCOUNTNAME -- 收款账户名称
    ,P1.COLLECTIONACCOUNTID -- 收款账户编号
    ,P1.COLLECTIONACCOUNTORGID -- 收款账户所属机构编号
    ,P1.RECOLLECTIONACCOUNTNAME -- 回款归集账户名称
    ,P1.RECOLLECTIONACCOUNTID -- 回款归集账户账号
    ,P1.RECOLLECTIONACCOUNTORGID -- 回款归集账户所属机构编号
    ,P1.PACKETWAREMAMATURITY -- 封包时加权剩余期限
    ,P1.PACKETWARATE*100 -- 封包时加权平均利率
    ,${iml_schema}.dateformat_min(P1.ACCRUEDCHARGEDATE) -- 费用计提日期
    ,P1.TOTALASSETPOOLSIZE -- 资产池实时规模
    ,decode(trim(P1.ISBAD),'Y','1','N','0','','-',trim(P1.ISBAD)) -- 不良资产标志
    ,${iml_schema}.dateformat_min(P1.UPDATETIME) -- 更新时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'abss_abs_asset_pool' -- 源表名称
    ,'abssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.abss_abs_asset_pool p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.ASSETPOOLSTATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ABSS'
        AND R2.SRC_TAB_EN_NAME= 'ABSS_ABS_ASSET_POOL'
        AND R2.SRC_FIELD_EN_NAME= 'ASSETPOOLSTATUS'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_ASSET_POOL_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'ASSET_POOL_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_asset_pool_info_h_abssf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_asset_pool_info_h_abssf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_pool_id -- 资产池编号
    ,asset_pool_name -- 资产池名称
    ,parent_asset_pool_id -- 父资产池编号
    ,asset_pool_type_cd -- 资产池类型代码
    ,asset_pool_char_cd -- 资产池性质代码
    ,asset_pool_status_cd -- 资产池状态代码
    ,pkg_flg -- 封包标志
    ,pkg_dt -- 封包日期
    ,tran_dt -- 转让日期
    ,recvbl_dt -- 收款日期
    ,pkg_day_asset_qtty -- 封包日资产数量
    ,pkg_day_asset_size -- 封包日资产规模
    ,tran_day_pric -- 转让日本金
    ,recvbl_day_pric -- 收款日本金
    ,actl_recvbl_amt -- 实际收款金额
    ,asset_pool_size -- 资产池规模
    ,unpkg_dt -- 解包日期
    ,end_type_cd -- 终结类型代码
    ,final_dt -- 终结日期
    ,add_pkg_asset_qtty -- 新增封包资产数量
    ,curr_cd -- 币种代码
    ,rgstrat_id -- 登记人编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_tm -- 登记时间
    ,asset_pool_acm_asset_size -- 资产池累计资产规模
    ,asset_pool_acm_asset_qtty -- 资产池累计资产数量
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_belong_org_id -- 收款账户所属机构编号
    ,return_coll_acct_name -- 回款归集账户名称
    ,return_coll_acct_num -- 回款归集账户账号
    ,coll_acct_belong_org_id -- 回款归集账户所属机构编号
    ,pkg_weight_surp_tenor -- 封包时加权剩余期限
    ,pkg_weight_avg_int_rat -- 封包时加权平均利率
    ,fee_provi_dt -- 费用计提日期
    ,asset_pool_realtm_size -- 资产池实时规模
    ,non_asset_flg -- 不良资产标志
    ,update_tm -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_asset_pool_info_h_abssf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_pool_id -- 资产池编号
    ,asset_pool_name -- 资产池名称
    ,parent_asset_pool_id -- 父资产池编号
    ,asset_pool_type_cd -- 资产池类型代码
    ,asset_pool_char_cd -- 资产池性质代码
    ,asset_pool_status_cd -- 资产池状态代码
    ,pkg_flg -- 封包标志
    ,pkg_dt -- 封包日期
    ,tran_dt -- 转让日期
    ,recvbl_dt -- 收款日期
    ,pkg_day_asset_qtty -- 封包日资产数量
    ,pkg_day_asset_size -- 封包日资产规模
    ,tran_day_pric -- 转让日本金
    ,recvbl_day_pric -- 收款日本金
    ,actl_recvbl_amt -- 实际收款金额
    ,asset_pool_size -- 资产池规模
    ,unpkg_dt -- 解包日期
    ,end_type_cd -- 终结类型代码
    ,final_dt -- 终结日期
    ,add_pkg_asset_qtty -- 新增封包资产数量
    ,curr_cd -- 币种代码
    ,rgstrat_id -- 登记人编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_tm -- 登记时间
    ,asset_pool_acm_asset_size -- 资产池累计资产规模
    ,asset_pool_acm_asset_qtty -- 资产池累计资产数量
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_belong_org_id -- 收款账户所属机构编号
    ,return_coll_acct_name -- 回款归集账户名称
    ,return_coll_acct_num -- 回款归集账户账号
    ,coll_acct_belong_org_id -- 回款归集账户所属机构编号
    ,pkg_weight_surp_tenor -- 封包时加权剩余期限
    ,pkg_weight_avg_int_rat -- 封包时加权平均利率
    ,fee_provi_dt -- 费用计提日期
    ,asset_pool_realtm_size -- 资产池实时规模
    ,non_asset_flg -- 不良资产标志
    ,update_tm -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.asset_pool_id, o.asset_pool_id) as asset_pool_id -- 资产池编号
    ,nvl(n.asset_pool_name, o.asset_pool_name) as asset_pool_name -- 资产池名称
    ,nvl(n.parent_asset_pool_id, o.parent_asset_pool_id) as parent_asset_pool_id -- 父资产池编号
    ,nvl(n.asset_pool_type_cd, o.asset_pool_type_cd) as asset_pool_type_cd -- 资产池类型代码
    ,nvl(n.asset_pool_char_cd, o.asset_pool_char_cd) as asset_pool_char_cd -- 资产池性质代码
    ,nvl(n.asset_pool_status_cd, o.asset_pool_status_cd) as asset_pool_status_cd -- 资产池状态代码
    ,nvl(n.pkg_flg, o.pkg_flg) as pkg_flg -- 封包标志
    ,nvl(n.pkg_dt, o.pkg_dt) as pkg_dt -- 封包日期
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 转让日期
    ,nvl(n.recvbl_dt, o.recvbl_dt) as recvbl_dt -- 收款日期
    ,nvl(n.pkg_day_asset_qtty, o.pkg_day_asset_qtty) as pkg_day_asset_qtty -- 封包日资产数量
    ,nvl(n.pkg_day_asset_size, o.pkg_day_asset_size) as pkg_day_asset_size -- 封包日资产规模
    ,nvl(n.tran_day_pric, o.tran_day_pric) as tran_day_pric -- 转让日本金
    ,nvl(n.recvbl_day_pric, o.recvbl_day_pric) as recvbl_day_pric -- 收款日本金
    ,nvl(n.actl_recvbl_amt, o.actl_recvbl_amt) as actl_recvbl_amt -- 实际收款金额
    ,nvl(n.asset_pool_size, o.asset_pool_size) as asset_pool_size -- 资产池规模
    ,nvl(n.unpkg_dt, o.unpkg_dt) as unpkg_dt -- 解包日期
    ,nvl(n.end_type_cd, o.end_type_cd) as end_type_cd -- 终结类型代码
    ,nvl(n.final_dt, o.final_dt) as final_dt -- 终结日期
    ,nvl(n.add_pkg_asset_qtty, o.add_pkg_asset_qtty) as add_pkg_asset_qtty -- 新增封包资产数量
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.rgstrat_id, o.rgstrat_id) as rgstrat_id -- 登记人编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_tm, o.rgst_tm) as rgst_tm -- 登记时间
    ,nvl(n.asset_pool_acm_asset_size, o.asset_pool_acm_asset_size) as asset_pool_acm_asset_size -- 资产池累计资产规模
    ,nvl(n.asset_pool_acm_asset_qtty, o.asset_pool_acm_asset_qtty) as asset_pool_acm_asset_qtty -- 资产池累计资产数量
    ,nvl(n.recvbl_acct_name, o.recvbl_acct_name) as recvbl_acct_name -- 收款账户名称
    ,nvl(n.recvbl_acct_id, o.recvbl_acct_id) as recvbl_acct_id -- 收款账户编号
    ,nvl(n.recvbl_acct_belong_org_id, o.recvbl_acct_belong_org_id) as recvbl_acct_belong_org_id -- 收款账户所属机构编号
    ,nvl(n.return_coll_acct_name, o.return_coll_acct_name) as return_coll_acct_name -- 回款归集账户名称
    ,nvl(n.return_coll_acct_num, o.return_coll_acct_num) as return_coll_acct_num -- 回款归集账户账号
    ,nvl(n.coll_acct_belong_org_id, o.coll_acct_belong_org_id) as coll_acct_belong_org_id -- 回款归集账户所属机构编号
    ,nvl(n.pkg_weight_surp_tenor, o.pkg_weight_surp_tenor) as pkg_weight_surp_tenor -- 封包时加权剩余期限
    ,nvl(n.pkg_weight_avg_int_rat, o.pkg_weight_avg_int_rat) as pkg_weight_avg_int_rat -- 封包时加权平均利率
    ,nvl(n.fee_provi_dt, o.fee_provi_dt) as fee_provi_dt -- 费用计提日期
    ,nvl(n.asset_pool_realtm_size, o.asset_pool_realtm_size) as asset_pool_realtm_size -- 资产池实时规模
    ,nvl(n.non_asset_flg, o.non_asset_flg) as non_asset_flg -- 不良资产标志
    ,nvl(n.update_tm, o.update_tm) as update_tm -- 更新时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_asset_pool_info_h_abssf1_tm n
    full join (select * from ${iml_schema}.agt_asset_pool_info_h_abssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.asset_pool_id <> n.asset_pool_id
        or o.asset_pool_name <> n.asset_pool_name
        or o.parent_asset_pool_id <> n.parent_asset_pool_id
        or o.asset_pool_type_cd <> n.asset_pool_type_cd
        or o.asset_pool_char_cd <> n.asset_pool_char_cd
        or o.asset_pool_status_cd <> n.asset_pool_status_cd
        or o.pkg_flg <> n.pkg_flg
        or o.pkg_dt <> n.pkg_dt
        or o.tran_dt <> n.tran_dt
        or o.recvbl_dt <> n.recvbl_dt
        or o.pkg_day_asset_qtty <> n.pkg_day_asset_qtty
        or o.pkg_day_asset_size <> n.pkg_day_asset_size
        or o.tran_day_pric <> n.tran_day_pric
        or o.recvbl_day_pric <> n.recvbl_day_pric
        or o.actl_recvbl_amt <> n.actl_recvbl_amt
        or o.asset_pool_size <> n.asset_pool_size
        or o.unpkg_dt <> n.unpkg_dt
        or o.end_type_cd <> n.end_type_cd
        or o.final_dt <> n.final_dt
        or o.add_pkg_asset_qtty <> n.add_pkg_asset_qtty
        or o.curr_cd <> n.curr_cd
        or o.rgstrat_id <> n.rgstrat_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_tm <> n.rgst_tm
        or o.asset_pool_acm_asset_size <> n.asset_pool_acm_asset_size
        or o.asset_pool_acm_asset_qtty <> n.asset_pool_acm_asset_qtty
        or o.recvbl_acct_name <> n.recvbl_acct_name
        or o.recvbl_acct_id <> n.recvbl_acct_id
        or o.recvbl_acct_belong_org_id <> n.recvbl_acct_belong_org_id
        or o.return_coll_acct_name <> n.return_coll_acct_name
        or o.return_coll_acct_num <> n.return_coll_acct_num
        or o.coll_acct_belong_org_id <> n.coll_acct_belong_org_id
        or o.pkg_weight_surp_tenor <> n.pkg_weight_surp_tenor
        or o.pkg_weight_avg_int_rat <> n.pkg_weight_avg_int_rat
        or o.fee_provi_dt <> n.fee_provi_dt
        or o.asset_pool_realtm_size <> n.asset_pool_realtm_size
        or o.non_asset_flg <> n.non_asset_flg
        or o.update_tm <> n.update_tm
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_asset_pool_info_h_abssf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_pool_id -- 资产池编号
    ,asset_pool_name -- 资产池名称
    ,parent_asset_pool_id -- 父资产池编号
    ,asset_pool_type_cd -- 资产池类型代码
    ,asset_pool_char_cd -- 资产池性质代码
    ,asset_pool_status_cd -- 资产池状态代码
    ,pkg_flg -- 封包标志
    ,pkg_dt -- 封包日期
    ,tran_dt -- 转让日期
    ,recvbl_dt -- 收款日期
    ,pkg_day_asset_qtty -- 封包日资产数量
    ,pkg_day_asset_size -- 封包日资产规模
    ,tran_day_pric -- 转让日本金
    ,recvbl_day_pric -- 收款日本金
    ,actl_recvbl_amt -- 实际收款金额
    ,asset_pool_size -- 资产池规模
    ,unpkg_dt -- 解包日期
    ,end_type_cd -- 终结类型代码
    ,final_dt -- 终结日期
    ,add_pkg_asset_qtty -- 新增封包资产数量
    ,curr_cd -- 币种代码
    ,rgstrat_id -- 登记人编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_tm -- 登记时间
    ,asset_pool_acm_asset_size -- 资产池累计资产规模
    ,asset_pool_acm_asset_qtty -- 资产池累计资产数量
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_belong_org_id -- 收款账户所属机构编号
    ,return_coll_acct_name -- 回款归集账户名称
    ,return_coll_acct_num -- 回款归集账户账号
    ,coll_acct_belong_org_id -- 回款归集账户所属机构编号
    ,pkg_weight_surp_tenor -- 封包时加权剩余期限
    ,pkg_weight_avg_int_rat -- 封包时加权平均利率
    ,fee_provi_dt -- 费用计提日期
    ,asset_pool_realtm_size -- 资产池实时规模
    ,non_asset_flg -- 不良资产标志
    ,update_tm -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_asset_pool_info_h_abssf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_pool_id -- 资产池编号
    ,asset_pool_name -- 资产池名称
    ,parent_asset_pool_id -- 父资产池编号
    ,asset_pool_type_cd -- 资产池类型代码
    ,asset_pool_char_cd -- 资产池性质代码
    ,asset_pool_status_cd -- 资产池状态代码
    ,pkg_flg -- 封包标志
    ,pkg_dt -- 封包日期
    ,tran_dt -- 转让日期
    ,recvbl_dt -- 收款日期
    ,pkg_day_asset_qtty -- 封包日资产数量
    ,pkg_day_asset_size -- 封包日资产规模
    ,tran_day_pric -- 转让日本金
    ,recvbl_day_pric -- 收款日本金
    ,actl_recvbl_amt -- 实际收款金额
    ,asset_pool_size -- 资产池规模
    ,unpkg_dt -- 解包日期
    ,end_type_cd -- 终结类型代码
    ,final_dt -- 终结日期
    ,add_pkg_asset_qtty -- 新增封包资产数量
    ,curr_cd -- 币种代码
    ,rgstrat_id -- 登记人编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_tm -- 登记时间
    ,asset_pool_acm_asset_size -- 资产池累计资产规模
    ,asset_pool_acm_asset_qtty -- 资产池累计资产数量
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_belong_org_id -- 收款账户所属机构编号
    ,return_coll_acct_name -- 回款归集账户名称
    ,return_coll_acct_num -- 回款归集账户账号
    ,coll_acct_belong_org_id -- 回款归集账户所属机构编号
    ,pkg_weight_surp_tenor -- 封包时加权剩余期限
    ,pkg_weight_avg_int_rat -- 封包时加权平均利率
    ,fee_provi_dt -- 费用计提日期
    ,asset_pool_realtm_size -- 资产池实时规模
    ,non_asset_flg -- 不良资产标志
    ,update_tm -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.asset_pool_id -- 资产池编号
    ,o.asset_pool_name -- 资产池名称
    ,o.parent_asset_pool_id -- 父资产池编号
    ,o.asset_pool_type_cd -- 资产池类型代码
    ,o.asset_pool_char_cd -- 资产池性质代码
    ,o.asset_pool_status_cd -- 资产池状态代码
    ,o.pkg_flg -- 封包标志
    ,o.pkg_dt -- 封包日期
    ,o.tran_dt -- 转让日期
    ,o.recvbl_dt -- 收款日期
    ,o.pkg_day_asset_qtty -- 封包日资产数量
    ,o.pkg_day_asset_size -- 封包日资产规模
    ,o.tran_day_pric -- 转让日本金
    ,o.recvbl_day_pric -- 收款日本金
    ,o.actl_recvbl_amt -- 实际收款金额
    ,o.asset_pool_size -- 资产池规模
    ,o.unpkg_dt -- 解包日期
    ,o.end_type_cd -- 终结类型代码
    ,o.final_dt -- 终结日期
    ,o.add_pkg_asset_qtty -- 新增封包资产数量
    ,o.curr_cd -- 币种代码
    ,o.rgstrat_id -- 登记人编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_tm -- 登记时间
    ,o.asset_pool_acm_asset_size -- 资产池累计资产规模
    ,o.asset_pool_acm_asset_qtty -- 资产池累计资产数量
    ,o.recvbl_acct_name -- 收款账户名称
    ,o.recvbl_acct_id -- 收款账户编号
    ,o.recvbl_acct_belong_org_id -- 收款账户所属机构编号
    ,o.return_coll_acct_name -- 回款归集账户名称
    ,o.return_coll_acct_num -- 回款归集账户账号
    ,o.coll_acct_belong_org_id -- 回款归集账户所属机构编号
    ,o.pkg_weight_surp_tenor -- 封包时加权剩余期限
    ,o.pkg_weight_avg_int_rat -- 封包时加权平均利率
    ,o.fee_provi_dt -- 费用计提日期
    ,o.asset_pool_realtm_size -- 资产池实时规模
    ,o.non_asset_flg -- 不良资产标志
    ,o.update_tm -- 更新时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_asset_pool_info_h_abssf1_bk o
    left join ${iml_schema}.agt_asset_pool_info_h_abssf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_asset_pool_info_h_abssf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_asset_pool_info_h;
--alter table ${iml_schema}.agt_asset_pool_info_h truncate partition for ('abssf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_asset_pool_info_h') 
               and substr(subpartition_name,1,8)=upper('p_abssf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_asset_pool_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_asset_pool_info_h modify partition p_abssf1 
add subpartition p_abssf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_asset_pool_info_h exchange subpartition p_abssf1_${batch_date} with table ${iml_schema}.agt_asset_pool_info_h_abssf1_cl;
alter table ${iml_schema}.agt_asset_pool_info_h exchange subpartition p_abssf1_20991231 with table ${iml_schema}.agt_asset_pool_info_h_abssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_asset_pool_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_asset_pool_info_h_abssf1_tm purge;
drop table ${iml_schema}.agt_asset_pool_info_h_abssf1_op purge;
drop table ${iml_schema}.agt_asset_pool_info_h_abssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_asset_pool_info_h_abssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_asset_pool_info_h', partname => 'p_abssf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
