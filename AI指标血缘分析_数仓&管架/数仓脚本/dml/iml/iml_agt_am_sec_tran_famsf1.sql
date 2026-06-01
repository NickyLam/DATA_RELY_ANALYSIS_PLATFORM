/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_am_sec_tran_famsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_am_sec_tran_famsf1_tm purge;
drop table ${iml_schema}.agt_am_sec_tran_famsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_am_sec_tran add partition p_famsf1 values ('famsf1')(
        subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_am_sec_tran modify partition p_famsf1
    add subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_am_sec_tran_famsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_am_sec_tran partition for ('famsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_am_sec_tran_famsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,bus_id -- 业务编号
    ,onl_flg -- 线上标志
    ,tran_dt -- 交易日期
    ,dlvy_dt -- 交割日期
    ,input_dt -- 录入日期
    ,cntpty_id -- 交易对手编号
    ,cntpty_type_cd -- 交易对手类型代码
    ,ghb_acct_id -- 本方账户编号
    ,tran_dir_cd -- 交易方向代码
    ,prod_id -- 产品编号
    ,cert_face_tot -- 券面总额
    ,net_price_amt -- 净价金额
    ,full_price_amt -- 全价金额
    ,acru_int -- 应计利息
    ,net_price_tot -- 净价总额
    ,full_price_tot -- 全价总额
    ,acru_int_tot -- 应计利息总额
    ,stl_way_cd -- 结算方式代码
    ,valid_flg -- 有效标志
    ,input_way_cd -- 录入方式代码
    ,ghb_dealer_id -- 本方交易员编号
    ,cntpty_dealer_id -- 对手方交易员编号
    ,asset_cls4_cd -- 资产四分类代码
    ,exp_yld_rat -- 到期收益率
    ,effect_dt -- 生效日期
    ,revo_dt -- 撤销日期
    ,bag_dt -- 成交日期
    ,parent_tran_id -- 父交易编号
    ,init_tran_id -- 原交易编号
    ,trans_flow_num -- 转仓流水号
    ,rev_tran_flow_num -- 反向交易流水号
    ,splt_tran_flg -- 拆分交易标志
    ,asset_pool_flg -- 资产池标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_am_sec_tran
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_am_sec_tran_famsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_am_sec_tran partition for ('famsf1') where 0=1;

-- 2.1 insert data to tm table
-- fams_sec_trad_deal-
insert into ${iml_schema}.agt_am_sec_tran_famsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,bus_id -- 业务编号
    ,onl_flg -- 线上标志
    ,tran_dt -- 交易日期
    ,dlvy_dt -- 交割日期
    ,input_dt -- 录入日期
    ,cntpty_id -- 交易对手编号
    ,cntpty_type_cd -- 交易对手类型代码
    ,ghb_acct_id -- 本方账户编号
    ,tran_dir_cd -- 交易方向代码
    ,prod_id -- 产品编号
    ,cert_face_tot -- 券面总额
    ,net_price_amt -- 净价金额
    ,full_price_amt -- 全价金额
    ,acru_int -- 应计利息
    ,net_price_tot -- 净价总额
    ,full_price_tot -- 全价总额
    ,acru_int_tot -- 应计利息总额
    ,stl_way_cd -- 结算方式代码
    ,valid_flg -- 有效标志
    ,input_way_cd -- 录入方式代码
    ,ghb_dealer_id -- 本方交易员编号
    ,cntpty_dealer_id -- 对手方交易员编号
    ,asset_cls4_cd -- 资产四分类代码
    ,exp_yld_rat -- 到期收益率
    ,effect_dt -- 生效日期
    ,revo_dt -- 撤销日期
    ,bag_dt -- 成交日期
    ,parent_tran_id -- 父交易编号
    ,init_tran_id -- 原交易编号
    ,trans_flow_num -- 转仓流水号
    ,rev_tran_flow_num -- 反向交易流水号
    ,splt_tran_flg -- 拆分交易标志
    ,asset_pool_flg -- 资产池标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '225101'||P1.SEQNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SEQNO -- 交易流水号
    ,P1.TRADEID -- 业务编号
    ,P1.SOURCE -- 线上标志
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.DEALDATE)) -- 交易日期
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.VDATE)) -- 交割日期
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.INPUTDATE)) -- 录入日期
    ,P1.COUNTERID -- 交易对手编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.COUNTERTYPE END -- 交易对手类型代码
    ,P1.ACCOUNT -- 本方账户编号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.PS END -- 交易方向代码
    ,P1.SECID -- 产品编号
    ,P1.PRINAMT -- 券面总额
    ,P1.CLEANPRICE -- 净价金额
    ,P1.DIRTYPRICE -- 全价金额
    ,P1.ACCUIR -- 应计利息
    ,P1.CLEANPRICEAMT -- 净价总额
    ,P1.DIRTYPRICEAMT -- 全价总额
    ,P1.ACCUIRAMT -- 应计利息总额
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.BUYCLEARINGFORM END -- 结算方式代码
    ,P1.EFFECTFLAG -- 有效标志
    ,P1.CALTYPE -- 录入方式代码
    ,P1.HOMETRADER -- 本方交易员编号
    ,P1.COUNTERTRADER -- 对手方交易员编号
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.INVESTTYPE END -- 资产四分类代码
    ,P1.YIELD -- 到期收益率
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.EFFDATE)) -- 生效日期
    ,${iml_schema}.DATEFORMAT_MAX(to_char(P1.REVDATE)) -- 撤销日期
    ,${iml_schema}.DATEFORMAT_MAX(to_char(P1.PURPOSEDATE)) -- 成交日期
    ,P1.FATHERSEQNO -- 父交易编号
    ,P1.ORIGINALSEQNO -- 原交易编号
    ,P1.REFSEQNO -- 转仓流水号
    ,P1.REVSEQNO -- 反向交易流水号
    ,P1.SPLITFLAG -- 拆分交易标志
    ,P1.TRADEMODE -- 资产池标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_sec_trad_deal' -- 源表名称
    ,'famsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_sec_trad_deal p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.COUNTERTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FAMS'
        AND R1.SRC_TAB_EN_NAME= 'FAMS_SEC_TRAD_DEAL'
        AND R1.SRC_FIELD_EN_NAME= 'COUNTERTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_AM_SEC_TRAN'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CNTPTY_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.PS = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'FAMS'
        AND R3.SRC_TAB_EN_NAME= 'FAMS_SEC_TRAD_DEAL'
        AND R3.SRC_FIELD_EN_NAME= 'PS'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_AM_SEC_TRAN'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'TRAN_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.BUYCLEARINGFORM = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'FAMS'
        AND R2.SRC_TAB_EN_NAME= 'FAMS_SEC_TRAD_DEAL'
        AND R2.SRC_FIELD_EN_NAME= 'BUYCLEARINGFORM'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_AM_SEC_TRAN'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'STL_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.INVESTTYPE = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'FAMS'
        AND R4.SRC_TAB_EN_NAME= 'FAMS_SEC_TRAD_DEAL'
        AND R4.SRC_FIELD_EN_NAME= 'INVESTTYPE'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_AM_SEC_TRAN'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'ASSET_CLS4_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_am_sec_tran_famsf1_tm 
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_am_sec_tran_famsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,bus_id -- 业务编号
    ,onl_flg -- 线上标志
    ,tran_dt -- 交易日期
    ,dlvy_dt -- 交割日期
    ,input_dt -- 录入日期
    ,cntpty_id -- 交易对手编号
    ,cntpty_type_cd -- 交易对手类型代码
    ,ghb_acct_id -- 本方账户编号
    ,tran_dir_cd -- 交易方向代码
    ,prod_id -- 产品编号
    ,cert_face_tot -- 券面总额
    ,net_price_amt -- 净价金额
    ,full_price_amt -- 全价金额
    ,acru_int -- 应计利息
    ,net_price_tot -- 净价总额
    ,full_price_tot -- 全价总额
    ,acru_int_tot -- 应计利息总额
    ,stl_way_cd -- 结算方式代码
    ,valid_flg -- 有效标志
    ,input_way_cd -- 录入方式代码
    ,ghb_dealer_id -- 本方交易员编号
    ,cntpty_dealer_id -- 对手方交易员编号
    ,asset_cls4_cd -- 资产四分类代码
    ,exp_yld_rat -- 到期收益率
    ,effect_dt -- 生效日期
    ,revo_dt -- 撤销日期
    ,bag_dt -- 成交日期
    ,parent_tran_id -- 父交易编号
    ,init_tran_id -- 原交易编号
    ,trans_flow_num -- 转仓流水号
    ,rev_tran_flow_num -- 反向交易流水号
    ,splt_tran_flg -- 拆分交易标志
    ,asset_pool_flg -- 资产池标志
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.bus_id, o.bus_id) as bus_id -- 业务编号
    ,nvl(n.onl_flg, o.onl_flg) as onl_flg -- 线上标志
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.dlvy_dt, o.dlvy_dt) as dlvy_dt -- 交割日期
    ,nvl(n.input_dt, o.input_dt) as input_dt -- 录入日期
    ,nvl(n.cntpty_id, o.cntpty_id) as cntpty_id -- 交易对手编号
    ,nvl(n.cntpty_type_cd, o.cntpty_type_cd) as cntpty_type_cd -- 交易对手类型代码
    ,nvl(n.ghb_acct_id, o.ghb_acct_id) as ghb_acct_id -- 本方账户编号
    ,nvl(n.tran_dir_cd, o.tran_dir_cd) as tran_dir_cd -- 交易方向代码
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.cert_face_tot, o.cert_face_tot) as cert_face_tot -- 券面总额
    ,nvl(n.net_price_amt, o.net_price_amt) as net_price_amt -- 净价金额
    ,nvl(n.full_price_amt, o.full_price_amt) as full_price_amt -- 全价金额
    ,nvl(n.acru_int, o.acru_int) as acru_int -- 应计利息
    ,nvl(n.net_price_tot, o.net_price_tot) as net_price_tot -- 净价总额
    ,nvl(n.full_price_tot, o.full_price_tot) as full_price_tot -- 全价总额
    ,nvl(n.acru_int_tot, o.acru_int_tot) as acru_int_tot -- 应计利息总额
    ,nvl(n.stl_way_cd, o.stl_way_cd) as stl_way_cd -- 结算方式代码
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
    ,nvl(n.input_way_cd, o.input_way_cd) as input_way_cd -- 录入方式代码
    ,nvl(n.ghb_dealer_id, o.ghb_dealer_id) as ghb_dealer_id -- 本方交易员编号
    ,nvl(n.cntpty_dealer_id, o.cntpty_dealer_id) as cntpty_dealer_id -- 对手方交易员编号
    ,nvl(n.asset_cls4_cd, o.asset_cls4_cd) as asset_cls4_cd -- 资产四分类代码
    ,nvl(n.exp_yld_rat, o.exp_yld_rat) as exp_yld_rat -- 到期收益率
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.revo_dt, o.revo_dt) as revo_dt -- 撤销日期
    ,nvl(n.bag_dt, o.bag_dt) as bag_dt -- 成交日期
    ,nvl(n.parent_tran_id, o.parent_tran_id) as parent_tran_id -- 父交易编号
    ,nvl(n.init_tran_id, o.init_tran_id) as init_tran_id -- 原交易编号
    ,nvl(n.trans_flow_num, o.trans_flow_num) as trans_flow_num -- 转仓流水号
    ,nvl(n.rev_tran_flow_num, o.rev_tran_flow_num) as rev_tran_flow_num -- 反向交易流水号
    ,nvl(n.splt_tran_flg, o.splt_tran_flg) as splt_tran_flg -- 拆分交易标志
    ,nvl(n.asset_pool_flg, o.asset_pool_flg) as asset_pool_flg -- 资产池标志
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.tran_flow_num <> n.tran_flow_num
                or o.bus_id <> n.bus_id
                or o.onl_flg <> n.onl_flg
                or o.tran_dt <> n.tran_dt
                or o.dlvy_dt <> n.dlvy_dt
                or o.input_dt <> n.input_dt
                or o.cntpty_id <> n.cntpty_id
                or o.cntpty_type_cd <> n.cntpty_type_cd
                or o.ghb_acct_id <> n.ghb_acct_id
                or o.tran_dir_cd <> n.tran_dir_cd
                or o.prod_id <> n.prod_id
                or o.cert_face_tot <> n.cert_face_tot
                or o.net_price_amt <> n.net_price_amt
                or o.full_price_amt <> n.full_price_amt
                or o.acru_int <> n.acru_int
                or o.net_price_tot <> n.net_price_tot
                or o.full_price_tot <> n.full_price_tot
                or o.acru_int_tot <> n.acru_int_tot
                or o.stl_way_cd <> n.stl_way_cd
                or o.valid_flg <> n.valid_flg
                or o.input_way_cd <> n.input_way_cd
                or o.ghb_dealer_id <> n.ghb_dealer_id
                or o.cntpty_dealer_id <> n.cntpty_dealer_id
                or o.asset_cls4_cd <> n.asset_cls4_cd
                or o.exp_yld_rat <> n.exp_yld_rat
                or o.effect_dt <> n.effect_dt
                or o.revo_dt <> n.revo_dt
                or o.bag_dt <> n.bag_dt
                or o.parent_tran_id <> n.parent_tran_id
                or o.init_tran_id <> n.init_tran_id
                or o.trans_flow_num <> n.trans_flow_num
                or o.rev_tran_flow_num <> n.rev_tran_flow_num
                or o.splt_tran_flg <> n.splt_tran_flg
                or o.asset_pool_flg <> n.asset_pool_flg
            ) or (
                 case when (
                           n.agt_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_am_sec_tran_famsf1_tm n
    full join ${iml_schema}.agt_am_sec_tran_famsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_am_sec_tran truncate partition for ('famsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_am_sec_tran exchange subpartition p_famsf1_${batch_date} with table ${iml_schema}.agt_am_sec_tran_famsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_am_sec_tran drop subpartition p_famsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_am_sec_tran to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_am_sec_tran_famsf1_tm purge;
drop table ${iml_schema}.agt_am_sec_tran_famsf1_ex purge;
drop table ${iml_schema}.agt_am_sec_tran_famsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_am_sec_tran', partname => 'p_famsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);