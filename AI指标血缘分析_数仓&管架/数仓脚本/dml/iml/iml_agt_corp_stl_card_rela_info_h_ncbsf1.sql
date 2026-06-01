/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_corp_stl_card_rela_info_h_ncbsf1
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
alter table ${iml_schema}.agt_corp_stl_card_rela_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_corp_stl_card_rela_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_corp_stl_card_rela_info_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_corp_stl_card_rela_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_corp_stl_card_rela_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_corp_stl_card_rela_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_corp_stl_card_rela_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    vouch_id -- 凭证编号
    ,card_no -- 卡号
    ,acct_num_sub_acct_num -- 账号子账号
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,lp_id -- 法人编号
    ,card_prod_id -- 卡产品编号
    ,acct_curr_cd -- 账户币种代码
    ,cust_id -- 客户编号
    ,deflt_acct_num_flg -- 默认账号标志
    ,main_card_flg -- 主卡标志
    ,main_card_card_no -- 主卡卡号
    ,general_exch_flg -- 通兑标志
    ,auto_coll_seq_type_cd -- 自动归集顺序类型代码
    ,coll_seq_num -- 归集顺序号
    ,linkg_deduct_flg -- 联动扣款标志
    ,card_stop_use_flg -- 卡停用标志
    ,in_card_interturn_flg -- 卡内互转标志
    ,dep_flg -- 可存款标志
    ,tranbl_flg -- 可转出标志
    ,cash_flg -- 可取现标志
    ,inco_decide_expns_flg -- 以收定支标志
    ,tran_dt -- 交易日期
    ,tran_timestamp -- 交易时间
    ,tran_org_id -- 交易机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_corp_stl_card_rela_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_corp_stl_card_rela_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_corp_stl_card_rela_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_corp_stl_card_rela_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_corp_stl_card_rela_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_settle_card_real-1
insert into ${iml_schema}.agt_corp_stl_card_rela_info_h_ncbsf1_tm(
    vouch_id -- 凭证编号
    ,card_no -- 卡号
    ,acct_num_sub_acct_num -- 账号子账号
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,lp_id -- 法人编号
    ,card_prod_id -- 卡产品编号
    ,acct_curr_cd -- 账户币种代码
    ,cust_id -- 客户编号
    ,deflt_acct_num_flg -- 默认账号标志
    ,main_card_flg -- 主卡标志
    ,main_card_card_no -- 主卡卡号
    ,general_exch_flg -- 通兑标志
    ,auto_coll_seq_type_cd -- 自动归集顺序类型代码
    ,coll_seq_num -- 归集顺序号
    ,linkg_deduct_flg -- 联动扣款标志
    ,card_stop_use_flg -- 卡停用标志
    ,in_card_interturn_flg -- 卡内互转标志
    ,dep_flg -- 可存款标志
    ,tranbl_flg -- 可转出标志
    ,cash_flg -- 可取现标志
    ,inco_decide_expns_flg -- 以收定支标志
    ,tran_dt -- 交易日期
    ,tran_timestamp -- 交易时间
    ,tran_org_id -- 交易机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CARD_NO -- 凭证编号
    ,P1.CARD_NO -- 卡号
    ,P1.ACCT_SEQ_NO -- 账号子账号
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,P1.PROD_TYPE -- 账户产品编号
    ,'9999' -- 法人编号
    ,P1.CARD_PROD_TYPE -- 卡产品编号
    ,P1.ACCT_CCY -- 账户币种代码
    ,P1.CLIENT_NO -- 客户编号
    ,decode(P1.DEFAULT_FLAG,' ','-','Y','1','N','0',P1.DEFAULT_FLAG) -- 默认账号标志
    ,decode(P1.MAIN_CARD_FLAG,' ','-','Y','1','N','0',P1.MAIN_CARD_FLAG) -- 主卡标志
    ,P1.MAIN_CARD_NO -- 主卡卡号
    ,decode(trim(p1.ALL_DRA_IND),'','-','Y','1','N','0',p1.ALL_DRA_IND) -- 通兑标志
    ,nvl(trim(P1.COLLECT_ORDER),'-') -- 自动归集顺序类型代码
    ,P1.COLLECT_NO -- 归集顺序号
    ,decode(trim(p1.AUTO_COLLECT_FLAG),'','-','Y','1','N','0',p1.AUTO_COLLECT_FLAG) -- 联动扣款标志
    ,decode(P1.CARD_TRAN_FLAG,' ','-','Y','1','N','0',P1.CARD_TRAN_FLAG) -- 卡停用标志
    ,decode(trim(p1.CARD_TRANFORM_FLAG),'','-','Y','1','N','0',p1.CARD_TRANFORM_FLAG) -- 卡内互转标志
    ,decode(P1.CRET_TRANS_FLAG,' ','-','Y','1','N','0',P1.CRET_TRANS_FLAG) -- 可存款标志
    ,decode(P1.DEBT_TRANS_FLAG,' ','-','Y','1','N','0',P1.DEBT_TRANS_FLAG) -- 可转出标志
    ,decode(P1.IS_CASH_TRANS,' ','-','Y','1','N','0'，P1.IS_CASH_TRANS) -- 可取现标志
    ,decode(trim(p1.INC_EXP_FLAG),'','-','Y','1','N','0',p1.INC_EXP_FLAG) -- 以收定支标志
    ,P1.TRAN_DATE -- 交易日期
    ,iml.timeformat_max2(P1.TRAN_TIMESTAMP) -- 交易时间
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_settle_card_real' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_settle_card_real p1
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.BASE_ACCT_NO=p8.BASE_ACCT_NO and p8.BASE_ACCT_NO LIKE '0%'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_corp_stl_card_rela_info_h_ncbsf1_tm 
  	                                group by 
  	                                        vouch_id
  	                                        ,card_no
  	                                        ,acct_num_sub_acct_num
  	                                        ,cust_acct_num
  	                                        ,acct_prod_id
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
        into ${iml_schema}.agt_corp_stl_card_rela_info_h_ncbsf1_cl(
            vouch_id -- 凭证编号
    ,card_no -- 卡号
    ,acct_num_sub_acct_num -- 账号子账号
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,lp_id -- 法人编号
    ,card_prod_id -- 卡产品编号
    ,acct_curr_cd -- 账户币种代码
    ,cust_id -- 客户编号
    ,deflt_acct_num_flg -- 默认账号标志
    ,main_card_flg -- 主卡标志
    ,main_card_card_no -- 主卡卡号
    ,general_exch_flg -- 通兑标志
    ,auto_coll_seq_type_cd -- 自动归集顺序类型代码
    ,coll_seq_num -- 归集顺序号
    ,linkg_deduct_flg -- 联动扣款标志
    ,card_stop_use_flg -- 卡停用标志
    ,in_card_interturn_flg -- 卡内互转标志
    ,dep_flg -- 可存款标志
    ,tranbl_flg -- 可转出标志
    ,cash_flg -- 可取现标志
    ,inco_decide_expns_flg -- 以收定支标志
    ,tran_dt -- 交易日期
    ,tran_timestamp -- 交易时间
    ,tran_org_id -- 交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_corp_stl_card_rela_info_h_ncbsf1_op(
            vouch_id -- 凭证编号
    ,card_no -- 卡号
    ,acct_num_sub_acct_num -- 账号子账号
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,lp_id -- 法人编号
    ,card_prod_id -- 卡产品编号
    ,acct_curr_cd -- 账户币种代码
    ,cust_id -- 客户编号
    ,deflt_acct_num_flg -- 默认账号标志
    ,main_card_flg -- 主卡标志
    ,main_card_card_no -- 主卡卡号
    ,general_exch_flg -- 通兑标志
    ,auto_coll_seq_type_cd -- 自动归集顺序类型代码
    ,coll_seq_num -- 归集顺序号
    ,linkg_deduct_flg -- 联动扣款标志
    ,card_stop_use_flg -- 卡停用标志
    ,in_card_interturn_flg -- 卡内互转标志
    ,dep_flg -- 可存款标志
    ,tranbl_flg -- 可转出标志
    ,cash_flg -- 可取现标志
    ,inco_decide_expns_flg -- 以收定支标志
    ,tran_dt -- 交易日期
    ,tran_timestamp -- 交易时间
    ,tran_org_id -- 交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.vouch_id, o.vouch_id) as vouch_id -- 凭证编号
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.acct_num_sub_acct_num, o.acct_num_sub_acct_num) as acct_num_sub_acct_num -- 账号子账号
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.acct_prod_id, o.acct_prod_id) as acct_prod_id -- 账户产品编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.card_prod_id, o.card_prod_id) as card_prod_id -- 卡产品编号
    ,nvl(n.acct_curr_cd, o.acct_curr_cd) as acct_curr_cd -- 账户币种代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.deflt_acct_num_flg, o.deflt_acct_num_flg) as deflt_acct_num_flg -- 默认账号标志
    ,nvl(n.main_card_flg, o.main_card_flg) as main_card_flg -- 主卡标志
    ,nvl(n.main_card_card_no, o.main_card_card_no) as main_card_card_no -- 主卡卡号
    ,nvl(n.general_exch_flg, o.general_exch_flg) as general_exch_flg -- 通兑标志
    ,nvl(n.auto_coll_seq_type_cd, o.auto_coll_seq_type_cd) as auto_coll_seq_type_cd -- 自动归集顺序类型代码
    ,nvl(n.coll_seq_num, o.coll_seq_num) as coll_seq_num -- 归集顺序号
    ,nvl(n.linkg_deduct_flg, o.linkg_deduct_flg) as linkg_deduct_flg -- 联动扣款标志
    ,nvl(n.card_stop_use_flg, o.card_stop_use_flg) as card_stop_use_flg -- 卡停用标志
    ,nvl(n.in_card_interturn_flg, o.in_card_interturn_flg) as in_card_interturn_flg -- 卡内互转标志
    ,nvl(n.dep_flg, o.dep_flg) as dep_flg -- 可存款标志
    ,nvl(n.tranbl_flg, o.tranbl_flg) as tranbl_flg -- 可转出标志
    ,nvl(n.cash_flg, o.cash_flg) as cash_flg -- 可取现标志
    ,nvl(n.inco_decide_expns_flg, o.inco_decide_expns_flg) as inco_decide_expns_flg -- 以收定支标志
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,case when
            n.vouch_id is null
            and n.card_no is null
            and n.acct_num_sub_acct_num is null
            and n.cust_acct_num is null
            and n.acct_prod_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.vouch_id is null
            and n.card_no is null
            and n.acct_num_sub_acct_num is null
            and n.cust_acct_num is null
            and n.acct_prod_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.vouch_id is null
            and n.card_no is null
            and n.acct_num_sub_acct_num is null
            and n.cust_acct_num is null
            and n.acct_prod_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_corp_stl_card_rela_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_corp_stl_card_rela_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.vouch_id = n.vouch_id
            and o.card_no = n.card_no
            and o.acct_num_sub_acct_num = n.acct_num_sub_acct_num
            and o.cust_acct_num = n.cust_acct_num
            and o.acct_prod_id = n.acct_prod_id
            and o.lp_id = n.lp_id
where (
        o.vouch_id is null
        and o.card_no is null
        and o.acct_num_sub_acct_num is null
        and o.cust_acct_num is null
        and o.acct_prod_id is null
        and o.lp_id is null
    )
    or (
        n.vouch_id is null
        and n.card_no is null
        and n.acct_num_sub_acct_num is null
        and n.cust_acct_num is null
        and n.acct_prod_id is null
        and n.lp_id is null
    )
    or (
        o.card_prod_id <> n.card_prod_id
        or o.acct_curr_cd <> n.acct_curr_cd
        or o.cust_id <> n.cust_id
        or o.deflt_acct_num_flg <> n.deflt_acct_num_flg
        or o.main_card_flg <> n.main_card_flg
        or o.main_card_card_no <> n.main_card_card_no
        or o.general_exch_flg <> n.general_exch_flg
        or o.auto_coll_seq_type_cd <> n.auto_coll_seq_type_cd
        or o.coll_seq_num <> n.coll_seq_num
        or o.linkg_deduct_flg <> n.linkg_deduct_flg
        or o.card_stop_use_flg <> n.card_stop_use_flg
        or o.in_card_interturn_flg <> n.in_card_interturn_flg
        or o.dep_flg <> n.dep_flg
        or o.tranbl_flg <> n.tranbl_flg
        or o.cash_flg <> n.cash_flg
        or o.inco_decide_expns_flg <> n.inco_decide_expns_flg
        or o.tran_dt <> n.tran_dt
        or o.tran_timestamp <> n.tran_timestamp
        or o.tran_org_id <> n.tran_org_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_corp_stl_card_rela_info_h_ncbsf1_cl(
            vouch_id -- 凭证编号
    ,card_no -- 卡号
    ,acct_num_sub_acct_num -- 账号子账号
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,lp_id -- 法人编号
    ,card_prod_id -- 卡产品编号
    ,acct_curr_cd -- 账户币种代码
    ,cust_id -- 客户编号
    ,deflt_acct_num_flg -- 默认账号标志
    ,main_card_flg -- 主卡标志
    ,main_card_card_no -- 主卡卡号
    ,general_exch_flg -- 通兑标志
    ,auto_coll_seq_type_cd -- 自动归集顺序类型代码
    ,coll_seq_num -- 归集顺序号
    ,linkg_deduct_flg -- 联动扣款标志
    ,card_stop_use_flg -- 卡停用标志
    ,in_card_interturn_flg -- 卡内互转标志
    ,dep_flg -- 可存款标志
    ,tranbl_flg -- 可转出标志
    ,cash_flg -- 可取现标志
    ,inco_decide_expns_flg -- 以收定支标志
    ,tran_dt -- 交易日期
    ,tran_timestamp -- 交易时间
    ,tran_org_id -- 交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_corp_stl_card_rela_info_h_ncbsf1_op(
            vouch_id -- 凭证编号
    ,card_no -- 卡号
    ,acct_num_sub_acct_num -- 账号子账号
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,lp_id -- 法人编号
    ,card_prod_id -- 卡产品编号
    ,acct_curr_cd -- 账户币种代码
    ,cust_id -- 客户编号
    ,deflt_acct_num_flg -- 默认账号标志
    ,main_card_flg -- 主卡标志
    ,main_card_card_no -- 主卡卡号
    ,general_exch_flg -- 通兑标志
    ,auto_coll_seq_type_cd -- 自动归集顺序类型代码
    ,coll_seq_num -- 归集顺序号
    ,linkg_deduct_flg -- 联动扣款标志
    ,card_stop_use_flg -- 卡停用标志
    ,in_card_interturn_flg -- 卡内互转标志
    ,dep_flg -- 可存款标志
    ,tranbl_flg -- 可转出标志
    ,cash_flg -- 可取现标志
    ,inco_decide_expns_flg -- 以收定支标志
    ,tran_dt -- 交易日期
    ,tran_timestamp -- 交易时间
    ,tran_org_id -- 交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.vouch_id -- 凭证编号
    ,o.card_no -- 卡号
    ,o.acct_num_sub_acct_num -- 账号子账号
    ,o.cust_acct_num -- 客户账号
    ,o.acct_prod_id -- 账户产品编号
    ,o.lp_id -- 法人编号
    ,o.card_prod_id -- 卡产品编号
    ,o.acct_curr_cd -- 账户币种代码
    ,o.cust_id -- 客户编号
    ,o.deflt_acct_num_flg -- 默认账号标志
    ,o.main_card_flg -- 主卡标志
    ,o.main_card_card_no -- 主卡卡号
    ,o.general_exch_flg -- 通兑标志
    ,o.auto_coll_seq_type_cd -- 自动归集顺序类型代码
    ,o.coll_seq_num -- 归集顺序号
    ,o.linkg_deduct_flg -- 联动扣款标志
    ,o.card_stop_use_flg -- 卡停用标志
    ,o.in_card_interturn_flg -- 卡内互转标志
    ,o.dep_flg -- 可存款标志
    ,o.tranbl_flg -- 可转出标志
    ,o.cash_flg -- 可取现标志
    ,o.inco_decide_expns_flg -- 以收定支标志
    ,o.tran_dt -- 交易日期
    ,o.tran_timestamp -- 交易时间
    ,o.tran_org_id -- 交易机构编号
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
from ${iml_schema}.agt_corp_stl_card_rela_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_corp_stl_card_rela_info_h_ncbsf1_op n
        on
            o.vouch_id = n.vouch_id
            and o.card_no = n.card_no
            and o.acct_num_sub_acct_num = n.acct_num_sub_acct_num
            and o.cust_acct_num = n.cust_acct_num
            and o.acct_prod_id = n.acct_prod_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_corp_stl_card_rela_info_h_ncbsf1_cl d
        on
            o.vouch_id = d.vouch_id
            and o.card_no = d.card_no
            and o.acct_num_sub_acct_num = d.acct_num_sub_acct_num
            and o.cust_acct_num = d.cust_acct_num
            and o.acct_prod_id = d.acct_prod_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_corp_stl_card_rela_info_h;
--alter table ${iml_schema}.agt_corp_stl_card_rela_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_corp_stl_card_rela_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_corp_stl_card_rela_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_corp_stl_card_rela_info_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_corp_stl_card_rela_info_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_corp_stl_card_rela_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_corp_stl_card_rela_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_corp_stl_card_rela_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_corp_stl_card_rela_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_corp_stl_card_rela_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_corp_stl_card_rela_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_corp_stl_card_rela_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_corp_stl_card_rela_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_corp_stl_card_rela_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
