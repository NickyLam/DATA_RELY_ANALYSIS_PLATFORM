/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_abs_cont_h_ncbsf1
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
alter table ${iml_schema}.agt_abs_cont_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_abs_cont_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_abs_cont_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_abs_cont_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_abs_cont_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_abs_cont_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_abs_cont_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_bag_cont_id -- 资产包合同编号
    ,curr_cd -- 币种代码
    ,bus_tran_dt -- 业务交易日期
    ,prod_id -- 产品编号
    ,acct_aldy_check_flg -- 账户已复核标志
    ,asset_bag_id -- 资产包编号
    ,asset_bag_name -- 资产包名称
    ,asset_bag_amt -- 资产包金额
    ,asset_bag_cont_seq_num -- 资产包合同序号
    ,asset_bag_cont_type_cd -- 资产包合同类型代码
    ,asset_bag_cont_status_cd -- 资产包合同状态代码
    ,asset_bag_tran_type_cd -- 资产包转让类型代码
    ,non_asset_flg -- 不良资产标志
    ,issue_tran_tm -- 发行交易时间
    ,issue_revo_dt -- 发行撤销日期
    ,pkg_dt -- 封包日期
    ,pkg_tran_tm -- 封包交易时间
    ,issue_convt_prem -- 发行折溢价
    ,comp_int_tran_out_idf_cd -- 复利转出标识代码
    ,pnlt_tran_out_idf_cd -- 罚息转出标识代码
    ,int_tran_out_idf_cd -- 利息转出标识代码
    ,pl_calc_way_cd -- 损益计算方式代码
    ,imp_blank_draw_dt -- 重空出票日期
    ,redem_convt_prem -- 赎回折溢价
    ,redem_value_dt -- 赎回起息日期
    ,asset_redem_dt -- 资产赎回日期
    ,revo_pkg_dt -- 撤包日期
    ,tran_memo_descb -- 交易摘要描述
    ,tran_tm -- 交易时间
    ,tran_org_id -- 交易机构编号
    ,apv_teller_id -- 审批柜员编号
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,amorted_int -- 已摊销利息
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_abs_cont_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_abs_cont_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_abs_cont_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_abs_cont_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_abs_cont_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_cl_transfer_contract-1
insert into ${iml_schema}.agt_abs_cont_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_bag_cont_id -- 资产包合同编号
    ,curr_cd -- 币种代码
    ,bus_tran_dt -- 业务交易日期
    ,prod_id -- 产品编号
    ,acct_aldy_check_flg -- 账户已复核标志
    ,asset_bag_id -- 资产包编号
    ,asset_bag_name -- 资产包名称
    ,asset_bag_amt -- 资产包金额
    ,asset_bag_cont_seq_num -- 资产包合同序号
    ,asset_bag_cont_type_cd -- 资产包合同类型代码
    ,asset_bag_cont_status_cd -- 资产包合同状态代码
    ,asset_bag_tran_type_cd -- 资产包转让类型代码
    ,non_asset_flg -- 不良资产标志
    ,issue_tran_tm -- 发行交易时间
    ,issue_revo_dt -- 发行撤销日期
    ,pkg_dt -- 封包日期
    ,pkg_tran_tm -- 封包交易时间
    ,issue_convt_prem -- 发行折溢价
    ,comp_int_tran_out_idf_cd -- 复利转出标识代码
    ,pnlt_tran_out_idf_cd -- 罚息转出标识代码
    ,int_tran_out_idf_cd -- 利息转出标识代码
    ,pl_calc_way_cd -- 损益计算方式代码
    ,imp_blank_draw_dt -- 重空出票日期
    ,redem_convt_prem -- 赎回折溢价
    ,redem_value_dt -- 赎回起息日期
    ,asset_redem_dt -- 资产赎回日期
    ,revo_pkg_dt -- 撤包日期
    ,tran_memo_descb -- 交易摘要描述
    ,tran_tm -- 交易时间
    ,tran_org_id -- 交易机构编号
    ,apv_teller_id -- 审批柜员编号
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,amorted_int -- 已摊销利息
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300015'||P1.ASSET_CONTRACT_SEQ_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ASSET_CONTRACT_SEQ_NO -- 资产包合同编号
    ,P1.CCY -- 币种代码
    ,P1.TRAN_DATE -- 业务交易日期
    ,P1.PROD_TYPE -- 产品编号
    ,P1.APPR_FLAG -- 账户已复核标志
    ,P1.ASSET_CONTRACT_ID -- 资产包编号
    ,P1.ASSET_CONTRACT_NAME -- 资产包名称
    ,P1.ASSET_CONTRACT_AMT -- 资产包金额
    ,P1.ASSET_CONTRACT_NO -- 资产包合同序号
    ,P1.ASSET_CONTRACT_TYPE -- 资产包合同类型代码
    ,P1.ASSET_CONTRACT_STATUS -- 资产包合同状态代码
    ,nvl(trim(P1.ASSET_TRANSFER_TYPE),'-') -- 资产包转让类型代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.IS_BAD END -- 不良资产标志
    ,${iml_schema}.timeformat_min(regexp_replace(P1.SALE_TRAN_TIMESTAMP,':','.',20,1)) -- 发行交易时间
    ,P1.SALE_CANCEL_DATE -- 发行撤销日期
    ,P1.PACK_DATE -- 封包日期
    ,${iml_schema}.timeformat_min(regexp_replace(P1.PACK_TRAN_TIMESTAMP,':','.',20,1)) -- 封包交易时间
    ,P1.SALE_FLOAT_AMOUNT -- 发行折溢价
    ,P1.ASSET_ODI_FLAG -- 复利转出标识代码
    ,P1.ASSET_ODP_FLAG -- 罚息转出标识代码
    ,P1.ASSET_INT_FLAG -- 利息转出标识代码
    ,nvl(trim(P1.PROFIT_LOSS_CALC_METHOD),'-') -- 损益计算方式代码
    ,P1.SALE_DATE -- 重空出票日期
    ,P1.REDEEM_FLOAT_AMOUNT -- 赎回折溢价
    ,P1.REDEEM_INT_DATE -- 赎回起息日期
    ,P1.REDEEM_DATE -- 资产赎回日期
    ,P1.PACK_CANCEL_DATE -- 撤包日期
    ,P1.NARRATIVE -- 交易摘要描述
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.APPR_USER_ID -- 审批柜员编号
    ,P1.USER_ID -- 交易柜员编号
    ,P1.LAST_CHANGE_DATE -- 最后修改日期
    ,P1.AMORTIZED_INT -- 已摊销利息
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_transfer_contract' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_transfer_contract p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.IS_BAD=R1.SRC_CODE_VAL
           AND R1.SORC_SYS_CD= 'NCBS'
           AND R1.SRC_TAB_EN_NAME ='NCBS_CL_TRANSFER_CONTRACT'
           AND R1.SRC_FIELD_EN_NAME ='IS_BAD'
           AND R1.TARGET_TAB_EN_NAME='AGT_ABS_CONT_H'
           AND R1.TARGET_TAB_FIELD_EN_NAME='NON_ASSET_FLG'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_abs_cont_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,asset_bag_cont_id
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
        into ${iml_schema}.agt_abs_cont_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_bag_cont_id -- 资产包合同编号
    ,curr_cd -- 币种代码
    ,bus_tran_dt -- 业务交易日期
    ,prod_id -- 产品编号
    ,acct_aldy_check_flg -- 账户已复核标志
    ,asset_bag_id -- 资产包编号
    ,asset_bag_name -- 资产包名称
    ,asset_bag_amt -- 资产包金额
    ,asset_bag_cont_seq_num -- 资产包合同序号
    ,asset_bag_cont_type_cd -- 资产包合同类型代码
    ,asset_bag_cont_status_cd -- 资产包合同状态代码
    ,asset_bag_tran_type_cd -- 资产包转让类型代码
    ,non_asset_flg -- 不良资产标志
    ,issue_tran_tm -- 发行交易时间
    ,issue_revo_dt -- 发行撤销日期
    ,pkg_dt -- 封包日期
    ,pkg_tran_tm -- 封包交易时间
    ,issue_convt_prem -- 发行折溢价
    ,comp_int_tran_out_idf_cd -- 复利转出标识代码
    ,pnlt_tran_out_idf_cd -- 罚息转出标识代码
    ,int_tran_out_idf_cd -- 利息转出标识代码
    ,pl_calc_way_cd -- 损益计算方式代码
    ,imp_blank_draw_dt -- 重空出票日期
    ,redem_convt_prem -- 赎回折溢价
    ,redem_value_dt -- 赎回起息日期
    ,asset_redem_dt -- 资产赎回日期
    ,revo_pkg_dt -- 撤包日期
    ,tran_memo_descb -- 交易摘要描述
    ,tran_tm -- 交易时间
    ,tran_org_id -- 交易机构编号
    ,apv_teller_id -- 审批柜员编号
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,amorted_int -- 已摊销利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_abs_cont_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_bag_cont_id -- 资产包合同编号
    ,curr_cd -- 币种代码
    ,bus_tran_dt -- 业务交易日期
    ,prod_id -- 产品编号
    ,acct_aldy_check_flg -- 账户已复核标志
    ,asset_bag_id -- 资产包编号
    ,asset_bag_name -- 资产包名称
    ,asset_bag_amt -- 资产包金额
    ,asset_bag_cont_seq_num -- 资产包合同序号
    ,asset_bag_cont_type_cd -- 资产包合同类型代码
    ,asset_bag_cont_status_cd -- 资产包合同状态代码
    ,asset_bag_tran_type_cd -- 资产包转让类型代码
    ,non_asset_flg -- 不良资产标志
    ,issue_tran_tm -- 发行交易时间
    ,issue_revo_dt -- 发行撤销日期
    ,pkg_dt -- 封包日期
    ,pkg_tran_tm -- 封包交易时间
    ,issue_convt_prem -- 发行折溢价
    ,comp_int_tran_out_idf_cd -- 复利转出标识代码
    ,pnlt_tran_out_idf_cd -- 罚息转出标识代码
    ,int_tran_out_idf_cd -- 利息转出标识代码
    ,pl_calc_way_cd -- 损益计算方式代码
    ,imp_blank_draw_dt -- 重空出票日期
    ,redem_convt_prem -- 赎回折溢价
    ,redem_value_dt -- 赎回起息日期
    ,asset_redem_dt -- 资产赎回日期
    ,revo_pkg_dt -- 撤包日期
    ,tran_memo_descb -- 交易摘要描述
    ,tran_tm -- 交易时间
    ,tran_org_id -- 交易机构编号
    ,apv_teller_id -- 审批柜员编号
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,amorted_int -- 已摊销利息
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
    ,nvl(n.asset_bag_cont_id, o.asset_bag_cont_id) as asset_bag_cont_id -- 资产包合同编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.bus_tran_dt, o.bus_tran_dt) as bus_tran_dt -- 业务交易日期
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.acct_aldy_check_flg, o.acct_aldy_check_flg) as acct_aldy_check_flg -- 账户已复核标志
    ,nvl(n.asset_bag_id, o.asset_bag_id) as asset_bag_id -- 资产包编号
    ,nvl(n.asset_bag_name, o.asset_bag_name) as asset_bag_name -- 资产包名称
    ,nvl(n.asset_bag_amt, o.asset_bag_amt) as asset_bag_amt -- 资产包金额
    ,nvl(n.asset_bag_cont_seq_num, o.asset_bag_cont_seq_num) as asset_bag_cont_seq_num -- 资产包合同序号
    ,nvl(n.asset_bag_cont_type_cd, o.asset_bag_cont_type_cd) as asset_bag_cont_type_cd -- 资产包合同类型代码
    ,nvl(n.asset_bag_cont_status_cd, o.asset_bag_cont_status_cd) as asset_bag_cont_status_cd -- 资产包合同状态代码
    ,nvl(n.asset_bag_tran_type_cd, o.asset_bag_tran_type_cd) as asset_bag_tran_type_cd -- 资产包转让类型代码
    ,nvl(n.non_asset_flg, o.non_asset_flg) as non_asset_flg -- 不良资产标志
    ,nvl(n.issue_tran_tm, o.issue_tran_tm) as issue_tran_tm -- 发行交易时间
    ,nvl(n.issue_revo_dt, o.issue_revo_dt) as issue_revo_dt -- 发行撤销日期
    ,nvl(n.pkg_dt, o.pkg_dt) as pkg_dt -- 封包日期
    ,nvl(n.pkg_tran_tm, o.pkg_tran_tm) as pkg_tran_tm -- 封包交易时间
    ,nvl(n.issue_convt_prem, o.issue_convt_prem) as issue_convt_prem -- 发行折溢价
    ,nvl(n.comp_int_tran_out_idf_cd, o.comp_int_tran_out_idf_cd) as comp_int_tran_out_idf_cd -- 复利转出标识代码
    ,nvl(n.pnlt_tran_out_idf_cd, o.pnlt_tran_out_idf_cd) as pnlt_tran_out_idf_cd -- 罚息转出标识代码
    ,nvl(n.int_tran_out_idf_cd, o.int_tran_out_idf_cd) as int_tran_out_idf_cd -- 利息转出标识代码
    ,nvl(n.pl_calc_way_cd, o.pl_calc_way_cd) as pl_calc_way_cd -- 损益计算方式代码
    ,nvl(n.imp_blank_draw_dt, o.imp_blank_draw_dt) as imp_blank_draw_dt -- 重空出票日期
    ,nvl(n.redem_convt_prem, o.redem_convt_prem) as redem_convt_prem -- 赎回折溢价
    ,nvl(n.redem_value_dt, o.redem_value_dt) as redem_value_dt -- 赎回起息日期
    ,nvl(n.asset_redem_dt, o.asset_redem_dt) as asset_redem_dt -- 资产赎回日期
    ,nvl(n.revo_pkg_dt, o.revo_pkg_dt) as revo_pkg_dt -- 撤包日期
    ,nvl(n.tran_memo_descb, o.tran_memo_descb) as tran_memo_descb -- 交易摘要描述
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.apv_teller_id, o.apv_teller_id) as apv_teller_id -- 审批柜员编号
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,nvl(n.amorted_int, o.amorted_int) as amorted_int -- 已摊销利息
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.asset_bag_cont_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.asset_bag_cont_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.asset_bag_cont_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_abs_cont_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_abs_cont_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.asset_bag_cont_id = n.asset_bag_cont_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.asset_bag_cont_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.asset_bag_cont_id is null
    )
    or (
        o.curr_cd <> n.curr_cd
        or o.bus_tran_dt <> n.bus_tran_dt
        or o.prod_id <> n.prod_id
        or o.acct_aldy_check_flg <> n.acct_aldy_check_flg
        or o.asset_bag_id <> n.asset_bag_id
        or o.asset_bag_name <> n.asset_bag_name
        or o.asset_bag_amt <> n.asset_bag_amt
        or o.asset_bag_cont_seq_num <> n.asset_bag_cont_seq_num
        or o.asset_bag_cont_type_cd <> n.asset_bag_cont_type_cd
        or o.asset_bag_cont_status_cd <> n.asset_bag_cont_status_cd
        or o.asset_bag_tran_type_cd <> n.asset_bag_tran_type_cd
        or o.non_asset_flg <> n.non_asset_flg
        or o.issue_tran_tm <> n.issue_tran_tm
        or o.issue_revo_dt <> n.issue_revo_dt
        or o.pkg_dt <> n.pkg_dt
        or o.pkg_tran_tm <> n.pkg_tran_tm
        or o.issue_convt_prem <> n.issue_convt_prem
        or o.comp_int_tran_out_idf_cd <> n.comp_int_tran_out_idf_cd
        or o.pnlt_tran_out_idf_cd <> n.pnlt_tran_out_idf_cd
        or o.int_tran_out_idf_cd <> n.int_tran_out_idf_cd
        or o.pl_calc_way_cd <> n.pl_calc_way_cd
        or o.imp_blank_draw_dt <> n.imp_blank_draw_dt
        or o.redem_convt_prem <> n.redem_convt_prem
        or o.redem_value_dt <> n.redem_value_dt
        or o.asset_redem_dt <> n.asset_redem_dt
        or o.revo_pkg_dt <> n.revo_pkg_dt
        or o.tran_memo_descb <> n.tran_memo_descb
        or o.tran_tm <> n.tran_tm
        or o.tran_org_id <> n.tran_org_id
        or o.apv_teller_id <> n.apv_teller_id
        or o.tran_teller_id <> n.tran_teller_id
        or o.final_modif_dt <> n.final_modif_dt
        or o.amorted_int <> n.amorted_int
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_abs_cont_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_bag_cont_id -- 资产包合同编号
    ,curr_cd -- 币种代码
    ,bus_tran_dt -- 业务交易日期
    ,prod_id -- 产品编号
    ,acct_aldy_check_flg -- 账户已复核标志
    ,asset_bag_id -- 资产包编号
    ,asset_bag_name -- 资产包名称
    ,asset_bag_amt -- 资产包金额
    ,asset_bag_cont_seq_num -- 资产包合同序号
    ,asset_bag_cont_type_cd -- 资产包合同类型代码
    ,asset_bag_cont_status_cd -- 资产包合同状态代码
    ,asset_bag_tran_type_cd -- 资产包转让类型代码
    ,non_asset_flg -- 不良资产标志
    ,issue_tran_tm -- 发行交易时间
    ,issue_revo_dt -- 发行撤销日期
    ,pkg_dt -- 封包日期
    ,pkg_tran_tm -- 封包交易时间
    ,issue_convt_prem -- 发行折溢价
    ,comp_int_tran_out_idf_cd -- 复利转出标识代码
    ,pnlt_tran_out_idf_cd -- 罚息转出标识代码
    ,int_tran_out_idf_cd -- 利息转出标识代码
    ,pl_calc_way_cd -- 损益计算方式代码
    ,imp_blank_draw_dt -- 重空出票日期
    ,redem_convt_prem -- 赎回折溢价
    ,redem_value_dt -- 赎回起息日期
    ,asset_redem_dt -- 资产赎回日期
    ,revo_pkg_dt -- 撤包日期
    ,tran_memo_descb -- 交易摘要描述
    ,tran_tm -- 交易时间
    ,tran_org_id -- 交易机构编号
    ,apv_teller_id -- 审批柜员编号
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,amorted_int -- 已摊销利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_abs_cont_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_bag_cont_id -- 资产包合同编号
    ,curr_cd -- 币种代码
    ,bus_tran_dt -- 业务交易日期
    ,prod_id -- 产品编号
    ,acct_aldy_check_flg -- 账户已复核标志
    ,asset_bag_id -- 资产包编号
    ,asset_bag_name -- 资产包名称
    ,asset_bag_amt -- 资产包金额
    ,asset_bag_cont_seq_num -- 资产包合同序号
    ,asset_bag_cont_type_cd -- 资产包合同类型代码
    ,asset_bag_cont_status_cd -- 资产包合同状态代码
    ,asset_bag_tran_type_cd -- 资产包转让类型代码
    ,non_asset_flg -- 不良资产标志
    ,issue_tran_tm -- 发行交易时间
    ,issue_revo_dt -- 发行撤销日期
    ,pkg_dt -- 封包日期
    ,pkg_tran_tm -- 封包交易时间
    ,issue_convt_prem -- 发行折溢价
    ,comp_int_tran_out_idf_cd -- 复利转出标识代码
    ,pnlt_tran_out_idf_cd -- 罚息转出标识代码
    ,int_tran_out_idf_cd -- 利息转出标识代码
    ,pl_calc_way_cd -- 损益计算方式代码
    ,imp_blank_draw_dt -- 重空出票日期
    ,redem_convt_prem -- 赎回折溢价
    ,redem_value_dt -- 赎回起息日期
    ,asset_redem_dt -- 资产赎回日期
    ,revo_pkg_dt -- 撤包日期
    ,tran_memo_descb -- 交易摘要描述
    ,tran_tm -- 交易时间
    ,tran_org_id -- 交易机构编号
    ,apv_teller_id -- 审批柜员编号
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,amorted_int -- 已摊销利息
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
    ,o.asset_bag_cont_id -- 资产包合同编号
    ,o.curr_cd -- 币种代码
    ,o.bus_tran_dt -- 业务交易日期
    ,o.prod_id -- 产品编号
    ,o.acct_aldy_check_flg -- 账户已复核标志
    ,o.asset_bag_id -- 资产包编号
    ,o.asset_bag_name -- 资产包名称
    ,o.asset_bag_amt -- 资产包金额
    ,o.asset_bag_cont_seq_num -- 资产包合同序号
    ,o.asset_bag_cont_type_cd -- 资产包合同类型代码
    ,o.asset_bag_cont_status_cd -- 资产包合同状态代码
    ,o.asset_bag_tran_type_cd -- 资产包转让类型代码
    ,o.non_asset_flg -- 不良资产标志
    ,o.issue_tran_tm -- 发行交易时间
    ,o.issue_revo_dt -- 发行撤销日期
    ,o.pkg_dt -- 封包日期
    ,o.pkg_tran_tm -- 封包交易时间
    ,o.issue_convt_prem -- 发行折溢价
    ,o.comp_int_tran_out_idf_cd -- 复利转出标识代码
    ,o.pnlt_tran_out_idf_cd -- 罚息转出标识代码
    ,o.int_tran_out_idf_cd -- 利息转出标识代码
    ,o.pl_calc_way_cd -- 损益计算方式代码
    ,o.imp_blank_draw_dt -- 重空出票日期
    ,o.redem_convt_prem -- 赎回折溢价
    ,o.redem_value_dt -- 赎回起息日期
    ,o.asset_redem_dt -- 资产赎回日期
    ,o.revo_pkg_dt -- 撤包日期
    ,o.tran_memo_descb -- 交易摘要描述
    ,o.tran_tm -- 交易时间
    ,o.tran_org_id -- 交易机构编号
    ,o.apv_teller_id -- 审批柜员编号
    ,o.tran_teller_id -- 交易柜员编号
    ,o.final_modif_dt -- 最后修改日期
    ,o.amorted_int -- 已摊销利息
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
from ${iml_schema}.agt_abs_cont_h_ncbsf1_bk o
    left join ${iml_schema}.agt_abs_cont_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.asset_bag_cont_id = n.asset_bag_cont_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_abs_cont_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.asset_bag_cont_id = d.asset_bag_cont_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_abs_cont_h;
--alter table ${iml_schema}.agt_abs_cont_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_abs_cont_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_abs_cont_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_abs_cont_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_abs_cont_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_abs_cont_h_ncbsf1_cl;
alter table ${iml_schema}.agt_abs_cont_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_abs_cont_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_abs_cont_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_abs_cont_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_abs_cont_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_abs_cont_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_abs_cont_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_abs_cont_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
