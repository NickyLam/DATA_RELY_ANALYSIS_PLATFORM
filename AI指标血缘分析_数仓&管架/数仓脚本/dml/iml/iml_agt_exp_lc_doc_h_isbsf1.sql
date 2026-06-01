/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_exp_lc_doc_h_isbsf1
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
alter table ${iml_schema}.agt_exp_lc_doc_h add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_isbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_exp_lc_doc_h_isbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_exp_lc_doc_h partition for ('isbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_exp_lc_doc_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_exp_lc_doc_h_isbsf1_op purge;
drop table ${iml_schema}.agt_exp_lc_doc_h_isbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_exp_lc_doc_h_isbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,doc_id -- 单据编号
    ,tran_descb -- 交易描述
    ,parent_bus_type_cd -- 父类业务类型代码
    ,parent_tran_intnal_id -- 父类交易内部编号
    ,sugst_pay_dt -- 提示付款日期
    ,cust_present_dt -- 客户交单日期
    ,shipment_dt -- 装船日期
    ,valid_pay_dt -- 有效付款日期
    ,doc_type_cd -- 单据类型代码
    ,teller_rgst_dt -- 柜员登记日期
    ,close_dt -- 闭卷日期
    ,acquiri_bank_rgst_dt -- 收单行登记日期
    ,bus_teller_id -- 业务柜员编号
    ,proof_nego_pay_flg -- 凭保议付标志
    ,noth_flg -- 无偿放单标志
    ,iss_ps_type_cd -- 出单人类型代码
    ,payer_type_cd -- 付款人类型代码
    ,margin_letter_revid_dt -- 保证金信件收到日期
    ,discrp_flg -- 不符点标志
    ,curt_acpt_flg -- 现在承兑标志
    ,curr_cd -- 币种代码
    ,pay_tot_amt -- 付款总金额
    ,pay_dt -- 付款日期
    ,doc_status_cd -- 单据状态代码
    ,doc_recv_ps_type_cd -- 单据接收人类型代码
    ,send_exp_other_addr_flg -- 送单到其他地址标志
    ,return_doc_flg -- 返还单据标志
    ,reim_bank_cd -- 偿付行代码
    ,overs_comm_fee -- 国外手续费
    ,trast_org_id -- 办理机构编号
    ,belong_org_id -- 所属机构编号
    ,nra_pay_flg -- NRA付款标志
    ,ship_odd_no -- 船运单号
    ,traff_doc_type_cd -- 运输单据类型代码
    ,traff_dt -- 运输日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_exp_lc_doc_h partition for ('isbsf1')
where 0=1
;

create table ${iml_schema}.agt_exp_lc_doc_h_isbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_exp_lc_doc_h partition for ('isbsf1') where 0=1;

create table ${iml_schema}.agt_exp_lc_doc_h_isbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_exp_lc_doc_h partition for ('isbsf1') where 0=1;

-- 3.1 get new data into table
-- isbs_bed-1
insert into ${iml_schema}.agt_exp_lc_doc_h_isbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,doc_id -- 单据编号
    ,tran_descb -- 交易描述
    ,parent_bus_type_cd -- 父类业务类型代码
    ,parent_tran_intnal_id -- 父类交易内部编号
    ,sugst_pay_dt -- 提示付款日期
    ,cust_present_dt -- 客户交单日期
    ,shipment_dt -- 装船日期
    ,valid_pay_dt -- 有效付款日期
    ,doc_type_cd -- 单据类型代码
    ,teller_rgst_dt -- 柜员登记日期
    ,close_dt -- 闭卷日期
    ,acquiri_bank_rgst_dt -- 收单行登记日期
    ,bus_teller_id -- 业务柜员编号
    ,proof_nego_pay_flg -- 凭保议付标志
    ,noth_flg -- 无偿放单标志
    ,iss_ps_type_cd -- 出单人类型代码
    ,payer_type_cd -- 付款人类型代码
    ,margin_letter_revid_dt -- 保证金信件收到日期
    ,discrp_flg -- 不符点标志
    ,curt_acpt_flg -- 现在承兑标志
    ,curr_cd -- 币种代码
    ,pay_tot_amt -- 付款总金额
    ,pay_dt -- 付款日期
    ,doc_status_cd -- 单据状态代码
    ,doc_recv_ps_type_cd -- 单据接收人类型代码
    ,send_exp_other_addr_flg -- 送单到其他地址标志
    ,return_doc_flg -- 返还单据标志
    ,reim_bank_cd -- 偿付行代码
    ,overs_comm_fee -- 国外手续费
    ,trast_org_id -- 办理机构编号
    ,belong_org_id -- 所属机构编号
    ,nra_pay_flg -- NRA付款标志
    ,ship_odd_no -- 船运单号
    ,traff_doc_type_cd -- 运输单据类型代码
    ,traff_dt -- 运输日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222310'||P1.INR -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INR -- 源协议编号
    ,P1.OWNREF -- 单据编号
    ,P1.NAM -- 交易描述
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.PNTTYP END -- 父类业务类型代码
    ,P1.PNTINR -- 父类交易内部编号
    ,P1.PREDAT -- 提示付款日期
    ,P1.RCVDAT -- 客户交单日期
    ,P1.SHPDAT -- 装船日期
    ,P1.MATDAT -- 有效付款日期
    ,nvl(trim(P1.DOCTYPCOD),'-') -- 单据类型代码
    ,P1.OPNDAT -- 柜员登记日期
    ,P1.CLSDAT -- 闭卷日期
    ,P1.CREDAT -- 收单行登记日期
    ,P1.OWNUSR -- 业务柜员编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.APPROVCOD END -- 凭保议付标志
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.FREPAYFLG END -- 无偿放单标志
    ,nvl(trim(P1.DOCPRBROL),'-') -- 出单人类型代码
    ,nvl(trim(P1.PAYROL),'-') -- 付款人类型代码
    ,P1.ORDDAT -- 保证金信件收到日期
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.DSCINSFLG END -- 不符点标志
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.ACPNOWFLG END -- 现在承兑标志
    ,nvl(trim(P1.TOTCUR),'-') -- 币种代码
    ,P1.TOTAMT -- 付款总金额
    ,P1.TOTDAT -- 付款日期
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.DOCSTA END -- 单据状态代码
    ,nvl(trim(P1.DOCROL),'-') -- 单据接收人类型代码
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.DOCROLFLG END -- 送单到其他地址标志
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.ADVDOCFLG END -- 返还单据标志
    ,nvl(trim(P1.RMBROL),'-') -- 偿付行代码
    ,P1.LESCOM -- 国外手续费
    ,P2.BRANCH -- 办理机构编号
    ,P3.BRANCH -- 所属机构编号
    ,CASE WHEN R9.TARGET_CD_VAL IS NOT NULL THEN R9.TARGET_CD_VAL ELSE '@'||P1.NRAFLG END -- NRA付款标志
    ,P1.TRPDOCNUM -- 船运单号
    ,nvl(trim(P1.TRPDOCTYP),'-') -- 运输单据类型代码
    ,P1.TRADAT -- 运输日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_bed' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_bed p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PNTTYP = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ISBS'
        AND R1.SRC_TAB_EN_NAME= 'ISBS_BED'
        AND R1.SRC_FIELD_EN_NAME= 'PNTTYP'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_EXP_LC_DOC_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PARENT_BUS_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.APPROVCOD = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ISBS'
        AND R2.SRC_TAB_EN_NAME= 'ISBS_BED'
        AND R2.SRC_FIELD_EN_NAME= 'APPROVCOD'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_EXP_LC_DOC_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'PROOF_NEGO_PAY_FLG'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.FREPAYFLG = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'ISBS'
        AND R3.SRC_TAB_EN_NAME= 'ISBS_BED'
        AND R3.SRC_FIELD_EN_NAME= 'FREPAYFLG'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_EXP_LC_DOC_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'NOTH_FLG'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.DSCINSFLG = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'ISBS'
        AND R4.SRC_TAB_EN_NAME= 'ISBS_BED'
        AND R4.SRC_FIELD_EN_NAME= 'DSCINSFLG'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_EXP_LC_DOC_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'DISCRP_FLG'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.ACPNOWFLG = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'ISBS'
        AND R5.SRC_TAB_EN_NAME= 'ISBS_BED'
        AND R5.SRC_FIELD_EN_NAME= 'ACPNOWFLG'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_EXP_LC_DOC_H'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'CURT_ACPT_FLG'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.DOCSTA = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'ISBS'
        AND R6.SRC_TAB_EN_NAME= 'ISBS_BED'
        AND R6.SRC_FIELD_EN_NAME= 'DOCSTA'
        AND R6.TARGET_TAB_EN_NAME= 'AGT_EXP_LC_DOC_H'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'DOC_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.DOCROLFLG = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'ISBS'
        AND R7.SRC_TAB_EN_NAME= 'ISBS_BED'
        AND R7.SRC_FIELD_EN_NAME= 'DOCROLFLG'
        AND R7.TARGET_TAB_EN_NAME= 'AGT_EXP_LC_DOC_H'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'SEND_EXP_OTHER_ADDR_FLG'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.ADVDOCFLG = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'ISBS'
        AND R8.SRC_TAB_EN_NAME= 'ISBS_BED'
        AND R8.SRC_FIELD_EN_NAME= 'ADVDOCFLG'
        AND R8.TARGET_TAB_EN_NAME= 'AGT_EXP_LC_DOC_H'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'RETURN_DOC_FLG'
    left join ${iol_schema}.isbs_bch p2 on P1.BCHKEYINR=p2.inr
and p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_bch p3 on P1.BRANCHINR=p3.inr
and p3.start_dt <= to_date('${batch_date}','yyyymmdd') and p3.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r9 on P1.NRAFLG = R9.SRC_CODE_VAL
        AND R9.SORC_SYS_CD= 'ISBS'
        AND R9.SRC_TAB_EN_NAME= 'ISBS_BED'
        AND R9.SRC_FIELD_EN_NAME= 'NRAFLG'
        AND R9.TARGET_TAB_EN_NAME= 'AGT_EXP_LC_DOC_H'
        AND R9.TARGET_TAB_FIELD_EN_NAME= 'NRA_PAY_FLG'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_exp_lc_doc_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,doc_id -- 单据编号
    ,tran_descb -- 交易描述
    ,parent_bus_type_cd -- 父类业务类型代码
    ,parent_tran_intnal_id -- 父类交易内部编号
    ,sugst_pay_dt -- 提示付款日期
    ,cust_present_dt -- 客户交单日期
    ,shipment_dt -- 装船日期
    ,valid_pay_dt -- 有效付款日期
    ,doc_type_cd -- 单据类型代码
    ,teller_rgst_dt -- 柜员登记日期
    ,close_dt -- 闭卷日期
    ,acquiri_bank_rgst_dt -- 收单行登记日期
    ,bus_teller_id -- 业务柜员编号
    ,proof_nego_pay_flg -- 凭保议付标志
    ,noth_flg -- 无偿放单标志
    ,iss_ps_type_cd -- 出单人类型代码
    ,payer_type_cd -- 付款人类型代码
    ,margin_letter_revid_dt -- 保证金信件收到日期
    ,discrp_flg -- 不符点标志
    ,curt_acpt_flg -- 现在承兑标志
    ,curr_cd -- 币种代码
    ,pay_tot_amt -- 付款总金额
    ,pay_dt -- 付款日期
    ,doc_status_cd -- 单据状态代码
    ,doc_recv_ps_type_cd -- 单据接收人类型代码
    ,send_exp_other_addr_flg -- 送单到其他地址标志
    ,return_doc_flg -- 返还单据标志
    ,reim_bank_cd -- 偿付行代码
    ,overs_comm_fee -- 国外手续费
    ,trast_org_id -- 办理机构编号
    ,belong_org_id -- 所属机构编号
    ,nra_pay_flg -- NRA付款标志
    ,ship_odd_no -- 船运单号
    ,traff_doc_type_cd -- 运输单据类型代码
    ,traff_dt -- 运输日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_exp_lc_doc_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,doc_id -- 单据编号
    ,tran_descb -- 交易描述
    ,parent_bus_type_cd -- 父类业务类型代码
    ,parent_tran_intnal_id -- 父类交易内部编号
    ,sugst_pay_dt -- 提示付款日期
    ,cust_present_dt -- 客户交单日期
    ,shipment_dt -- 装船日期
    ,valid_pay_dt -- 有效付款日期
    ,doc_type_cd -- 单据类型代码
    ,teller_rgst_dt -- 柜员登记日期
    ,close_dt -- 闭卷日期
    ,acquiri_bank_rgst_dt -- 收单行登记日期
    ,bus_teller_id -- 业务柜员编号
    ,proof_nego_pay_flg -- 凭保议付标志
    ,noth_flg -- 无偿放单标志
    ,iss_ps_type_cd -- 出单人类型代码
    ,payer_type_cd -- 付款人类型代码
    ,margin_letter_revid_dt -- 保证金信件收到日期
    ,discrp_flg -- 不符点标志
    ,curt_acpt_flg -- 现在承兑标志
    ,curr_cd -- 币种代码
    ,pay_tot_amt -- 付款总金额
    ,pay_dt -- 付款日期
    ,doc_status_cd -- 单据状态代码
    ,doc_recv_ps_type_cd -- 单据接收人类型代码
    ,send_exp_other_addr_flg -- 送单到其他地址标志
    ,return_doc_flg -- 返还单据标志
    ,reim_bank_cd -- 偿付行代码
    ,overs_comm_fee -- 国外手续费
    ,trast_org_id -- 办理机构编号
    ,belong_org_id -- 所属机构编号
    ,nra_pay_flg -- NRA付款标志
    ,ship_odd_no -- 船运单号
    ,traff_doc_type_cd -- 运输单据类型代码
    ,traff_dt -- 运输日期
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
    ,nvl(n.src_agt_id, o.src_agt_id) as src_agt_id -- 源协议编号
    ,nvl(n.doc_id, o.doc_id) as doc_id -- 单据编号
    ,nvl(n.tran_descb, o.tran_descb) as tran_descb -- 交易描述
    ,nvl(n.parent_bus_type_cd, o.parent_bus_type_cd) as parent_bus_type_cd -- 父类业务类型代码
    ,nvl(n.parent_tran_intnal_id, o.parent_tran_intnal_id) as parent_tran_intnal_id -- 父类交易内部编号
    ,nvl(n.sugst_pay_dt, o.sugst_pay_dt) as sugst_pay_dt -- 提示付款日期
    ,nvl(n.cust_present_dt, o.cust_present_dt) as cust_present_dt -- 客户交单日期
    ,nvl(n.shipment_dt, o.shipment_dt) as shipment_dt -- 装船日期
    ,nvl(n.valid_pay_dt, o.valid_pay_dt) as valid_pay_dt -- 有效付款日期
    ,nvl(n.doc_type_cd, o.doc_type_cd) as doc_type_cd -- 单据类型代码
    ,nvl(n.teller_rgst_dt, o.teller_rgst_dt) as teller_rgst_dt -- 柜员登记日期
    ,nvl(n.close_dt, o.close_dt) as close_dt -- 闭卷日期
    ,nvl(n.acquiri_bank_rgst_dt, o.acquiri_bank_rgst_dt) as acquiri_bank_rgst_dt -- 收单行登记日期
    ,nvl(n.bus_teller_id, o.bus_teller_id) as bus_teller_id -- 业务柜员编号
    ,nvl(n.proof_nego_pay_flg, o.proof_nego_pay_flg) as proof_nego_pay_flg -- 凭保议付标志
    ,nvl(n.noth_flg, o.noth_flg) as noth_flg -- 无偿放单标志
    ,nvl(n.iss_ps_type_cd, o.iss_ps_type_cd) as iss_ps_type_cd -- 出单人类型代码
    ,nvl(n.payer_type_cd, o.payer_type_cd) as payer_type_cd -- 付款人类型代码
    ,nvl(n.margin_letter_revid_dt, o.margin_letter_revid_dt) as margin_letter_revid_dt -- 保证金信件收到日期
    ,nvl(n.discrp_flg, o.discrp_flg) as discrp_flg -- 不符点标志
    ,nvl(n.curt_acpt_flg, o.curt_acpt_flg) as curt_acpt_flg -- 现在承兑标志
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.pay_tot_amt, o.pay_tot_amt) as pay_tot_amt -- 付款总金额
    ,nvl(n.pay_dt, o.pay_dt) as pay_dt -- 付款日期
    ,nvl(n.doc_status_cd, o.doc_status_cd) as doc_status_cd -- 单据状态代码
    ,nvl(n.doc_recv_ps_type_cd, o.doc_recv_ps_type_cd) as doc_recv_ps_type_cd -- 单据接收人类型代码
    ,nvl(n.send_exp_other_addr_flg, o.send_exp_other_addr_flg) as send_exp_other_addr_flg -- 送单到其他地址标志
    ,nvl(n.return_doc_flg, o.return_doc_flg) as return_doc_flg -- 返还单据标志
    ,nvl(n.reim_bank_cd, o.reim_bank_cd) as reim_bank_cd -- 偿付行代码
    ,nvl(n.overs_comm_fee, o.overs_comm_fee) as overs_comm_fee -- 国外手续费
    ,nvl(n.trast_org_id, o.trast_org_id) as trast_org_id -- 办理机构编号
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.nra_pay_flg, o.nra_pay_flg) as nra_pay_flg -- NRA付款标志
    ,nvl(n.ship_odd_no, o.ship_odd_no) as ship_odd_no -- 船运单号
    ,nvl(n.traff_doc_type_cd, o.traff_doc_type_cd) as traff_doc_type_cd -- 运输单据类型代码
    ,nvl(n.traff_dt, o.traff_dt) as traff_dt -- 运输日期
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
from ${iml_schema}.agt_exp_lc_doc_h_isbsf1_tm n
    full join (select * from ${iml_schema}.agt_exp_lc_doc_h_isbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.src_agt_id <> n.src_agt_id
        or o.doc_id <> n.doc_id
        or o.tran_descb <> n.tran_descb
        or o.parent_bus_type_cd <> n.parent_bus_type_cd
        or o.parent_tran_intnal_id <> n.parent_tran_intnal_id
        or o.sugst_pay_dt <> n.sugst_pay_dt
        or o.cust_present_dt <> n.cust_present_dt
        or o.shipment_dt <> n.shipment_dt
        or o.valid_pay_dt <> n.valid_pay_dt
        or o.doc_type_cd <> n.doc_type_cd
        or o.teller_rgst_dt <> n.teller_rgst_dt
        or o.close_dt <> n.close_dt
        or o.acquiri_bank_rgst_dt <> n.acquiri_bank_rgst_dt
        or o.bus_teller_id <> n.bus_teller_id
        or o.proof_nego_pay_flg <> n.proof_nego_pay_flg
        or o.noth_flg <> n.noth_flg
        or o.iss_ps_type_cd <> n.iss_ps_type_cd
        or o.payer_type_cd <> n.payer_type_cd
        or o.margin_letter_revid_dt <> n.margin_letter_revid_dt
        or o.discrp_flg <> n.discrp_flg
        or o.curt_acpt_flg <> n.curt_acpt_flg
        or o.curr_cd <> n.curr_cd
        or o.pay_tot_amt <> n.pay_tot_amt
        or o.pay_dt <> n.pay_dt
        or o.doc_status_cd <> n.doc_status_cd
        or o.doc_recv_ps_type_cd <> n.doc_recv_ps_type_cd
        or o.send_exp_other_addr_flg <> n.send_exp_other_addr_flg
        or o.return_doc_flg <> n.return_doc_flg
        or o.reim_bank_cd <> n.reim_bank_cd
        or o.overs_comm_fee <> n.overs_comm_fee
        or o.trast_org_id <> n.trast_org_id
        or o.belong_org_id <> n.belong_org_id
        or o.nra_pay_flg <> n.nra_pay_flg
        or o.ship_odd_no <> n.ship_odd_no
        or o.traff_doc_type_cd <> n.traff_doc_type_cd
        or o.traff_dt <> n.traff_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_exp_lc_doc_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,doc_id -- 单据编号
    ,tran_descb -- 交易描述
    ,parent_bus_type_cd -- 父类业务类型代码
    ,parent_tran_intnal_id -- 父类交易内部编号
    ,sugst_pay_dt -- 提示付款日期
    ,cust_present_dt -- 客户交单日期
    ,shipment_dt -- 装船日期
    ,valid_pay_dt -- 有效付款日期
    ,doc_type_cd -- 单据类型代码
    ,teller_rgst_dt -- 柜员登记日期
    ,close_dt -- 闭卷日期
    ,acquiri_bank_rgst_dt -- 收单行登记日期
    ,bus_teller_id -- 业务柜员编号
    ,proof_nego_pay_flg -- 凭保议付标志
    ,noth_flg -- 无偿放单标志
    ,iss_ps_type_cd -- 出单人类型代码
    ,payer_type_cd -- 付款人类型代码
    ,margin_letter_revid_dt -- 保证金信件收到日期
    ,discrp_flg -- 不符点标志
    ,curt_acpt_flg -- 现在承兑标志
    ,curr_cd -- 币种代码
    ,pay_tot_amt -- 付款总金额
    ,pay_dt -- 付款日期
    ,doc_status_cd -- 单据状态代码
    ,doc_recv_ps_type_cd -- 单据接收人类型代码
    ,send_exp_other_addr_flg -- 送单到其他地址标志
    ,return_doc_flg -- 返还单据标志
    ,reim_bank_cd -- 偿付行代码
    ,overs_comm_fee -- 国外手续费
    ,trast_org_id -- 办理机构编号
    ,belong_org_id -- 所属机构编号
    ,nra_pay_flg -- NRA付款标志
    ,ship_odd_no -- 船运单号
    ,traff_doc_type_cd -- 运输单据类型代码
    ,traff_dt -- 运输日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_exp_lc_doc_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,doc_id -- 单据编号
    ,tran_descb -- 交易描述
    ,parent_bus_type_cd -- 父类业务类型代码
    ,parent_tran_intnal_id -- 父类交易内部编号
    ,sugst_pay_dt -- 提示付款日期
    ,cust_present_dt -- 客户交单日期
    ,shipment_dt -- 装船日期
    ,valid_pay_dt -- 有效付款日期
    ,doc_type_cd -- 单据类型代码
    ,teller_rgst_dt -- 柜员登记日期
    ,close_dt -- 闭卷日期
    ,acquiri_bank_rgst_dt -- 收单行登记日期
    ,bus_teller_id -- 业务柜员编号
    ,proof_nego_pay_flg -- 凭保议付标志
    ,noth_flg -- 无偿放单标志
    ,iss_ps_type_cd -- 出单人类型代码
    ,payer_type_cd -- 付款人类型代码
    ,margin_letter_revid_dt -- 保证金信件收到日期
    ,discrp_flg -- 不符点标志
    ,curt_acpt_flg -- 现在承兑标志
    ,curr_cd -- 币种代码
    ,pay_tot_amt -- 付款总金额
    ,pay_dt -- 付款日期
    ,doc_status_cd -- 单据状态代码
    ,doc_recv_ps_type_cd -- 单据接收人类型代码
    ,send_exp_other_addr_flg -- 送单到其他地址标志
    ,return_doc_flg -- 返还单据标志
    ,reim_bank_cd -- 偿付行代码
    ,overs_comm_fee -- 国外手续费
    ,trast_org_id -- 办理机构编号
    ,belong_org_id -- 所属机构编号
    ,nra_pay_flg -- NRA付款标志
    ,ship_odd_no -- 船运单号
    ,traff_doc_type_cd -- 运输单据类型代码
    ,traff_dt -- 运输日期
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
    ,o.src_agt_id -- 源协议编号
    ,o.doc_id -- 单据编号
    ,o.tran_descb -- 交易描述
    ,o.parent_bus_type_cd -- 父类业务类型代码
    ,o.parent_tran_intnal_id -- 父类交易内部编号
    ,o.sugst_pay_dt -- 提示付款日期
    ,o.cust_present_dt -- 客户交单日期
    ,o.shipment_dt -- 装船日期
    ,o.valid_pay_dt -- 有效付款日期
    ,o.doc_type_cd -- 单据类型代码
    ,o.teller_rgst_dt -- 柜员登记日期
    ,o.close_dt -- 闭卷日期
    ,o.acquiri_bank_rgst_dt -- 收单行登记日期
    ,o.bus_teller_id -- 业务柜员编号
    ,o.proof_nego_pay_flg -- 凭保议付标志
    ,o.noth_flg -- 无偿放单标志
    ,o.iss_ps_type_cd -- 出单人类型代码
    ,o.payer_type_cd -- 付款人类型代码
    ,o.margin_letter_revid_dt -- 保证金信件收到日期
    ,o.discrp_flg -- 不符点标志
    ,o.curt_acpt_flg -- 现在承兑标志
    ,o.curr_cd -- 币种代码
    ,o.pay_tot_amt -- 付款总金额
    ,o.pay_dt -- 付款日期
    ,o.doc_status_cd -- 单据状态代码
    ,o.doc_recv_ps_type_cd -- 单据接收人类型代码
    ,o.send_exp_other_addr_flg -- 送单到其他地址标志
    ,o.return_doc_flg -- 返还单据标志
    ,o.reim_bank_cd -- 偿付行代码
    ,o.overs_comm_fee -- 国外手续费
    ,o.trast_org_id -- 办理机构编号
    ,o.belong_org_id -- 所属机构编号
    ,o.nra_pay_flg -- NRA付款标志
    ,o.ship_odd_no -- 船运单号
    ,o.traff_doc_type_cd -- 运输单据类型代码
    ,o.traff_dt -- 运输日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_exp_lc_doc_h_isbsf1_bk o
    left join ${iml_schema}.agt_exp_lc_doc_h_isbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_exp_lc_doc_h_isbsf1_cl d
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
--truncate table ${iml_schema}.agt_exp_lc_doc_h;
alter table ${iml_schema}.agt_exp_lc_doc_h truncate partition for ('isbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_exp_lc_doc_h exchange subpartition p_isbsf1_19000101 with table ${iml_schema}.agt_exp_lc_doc_h_isbsf1_cl;
alter table ${iml_schema}.agt_exp_lc_doc_h exchange subpartition p_isbsf1_20991231 with table ${iml_schema}.agt_exp_lc_doc_h_isbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_exp_lc_doc_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_exp_lc_doc_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_exp_lc_doc_h_isbsf1_op purge;
drop table ${iml_schema}.agt_exp_lc_doc_h_isbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_exp_lc_doc_h_isbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_exp_lc_doc_h', partname => 'p_isbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
