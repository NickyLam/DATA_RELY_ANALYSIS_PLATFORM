/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_imp_lc_doc_h_isbsf1
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
alter table ${iml_schema}.agt_imp_lc_doc_h add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_isbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_imp_lc_doc_h_isbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_imp_lc_doc_h partition for ('isbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_imp_lc_doc_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_imp_lc_doc_h_isbsf1_op purge;
drop table ${iml_schema}.agt_imp_lc_doc_h_isbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_imp_lc_doc_h_isbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,bill_bus_id -- 票据业务编号
    ,tran_descb -- 交易描述
    ,bus_teller_id -- 业务柜员编号
    ,sys_rgst_dt -- 系统登记日期
    ,bus_rgst_dt -- 业务登记日期
    ,close_dt -- 闭卷日期
    ,parent_bus_type_cd -- 父类业务类型代码
    ,parent_tran_intnal_id -- 父类交易内部编号
    ,send_bill_bk_send_bill_dt -- 寄单行寄单日期
    ,latest_ship_dt -- 最迟装运日期
    ,delay_pay_exp_dt -- 延期付款到期日期
    ,load_bill_revid_dt -- 提单收到日期
    ,discrp_advise_dt -- 不符点通知日期
    ,doc_type_cd -- 单据类型代码
    ,refuse_pay_flg_cd -- 拒付标志代码
    ,apprv_flg -- 批准标志
    ,goods_way_cd -- 放货方式代码
    ,auth_goods_dt -- 授权放货日期
    ,free_pay_present_flg -- 免付款交单标志
    ,recv_advise_type_cd -- 接收通知类型代码
    ,pick_goods_guar_open_dt -- 提货担保开立日期
    ,traff_doc_type_cd -- 运输单据类型代码
    ,traff_dt -- 运输日期
    ,multi_tenor_flg -- 多期限标志
    ,doc_diff_flg -- 单据差异标志
    ,submit_role_type_cd -- 提交角色类型代码
    ,doc_status_cd -- 单据状态代码
    ,ignore_discrp_flg -- 忽略不符点标志
    ,curr_cd -- 币种代码
    ,pay_tot_amt -- 付款总金额
    ,payer_type_cd -- 付款人类型代码
    ,acpt_flg -- 承兑标志
    ,income_bill_dt -- 来单日期
    ,chargeback_flg -- 退单标志
    ,trast_org_id -- 办理机构编号
    ,belong_org_id -- 所属机构编号
    ,load_bill_num -- 提单号
    ,nra_pay_flg -- NRA付款标志
    ,clear_chn_cd -- 清算渠道代码
    ,inv_id -- 发票编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_imp_lc_doc_h partition for ('isbsf1')
where 0=1
;

create table ${iml_schema}.agt_imp_lc_doc_h_isbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_imp_lc_doc_h partition for ('isbsf1') where 0=1;

create table ${iml_schema}.agt_imp_lc_doc_h_isbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_imp_lc_doc_h partition for ('isbsf1') where 0=1;

-- 3.1 get new data into table
-- isbs_brd-1
insert into ${iml_schema}.agt_imp_lc_doc_h_isbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,bill_bus_id -- 票据业务编号
    ,tran_descb -- 交易描述
    ,bus_teller_id -- 业务柜员编号
    ,sys_rgst_dt -- 系统登记日期
    ,bus_rgst_dt -- 业务登记日期
    ,close_dt -- 闭卷日期
    ,parent_bus_type_cd -- 父类业务类型代码
    ,parent_tran_intnal_id -- 父类交易内部编号
    ,send_bill_bk_send_bill_dt -- 寄单行寄单日期
    ,latest_ship_dt -- 最迟装运日期
    ,delay_pay_exp_dt -- 延期付款到期日期
    ,load_bill_revid_dt -- 提单收到日期
    ,discrp_advise_dt -- 不符点通知日期
    ,doc_type_cd -- 单据类型代码
    ,refuse_pay_flg_cd -- 拒付标志代码
    ,apprv_flg -- 批准标志
    ,goods_way_cd -- 放货方式代码
    ,auth_goods_dt -- 授权放货日期
    ,free_pay_present_flg -- 免付款交单标志
    ,recv_advise_type_cd -- 接收通知类型代码
    ,pick_goods_guar_open_dt -- 提货担保开立日期
    ,traff_doc_type_cd -- 运输单据类型代码
    ,traff_dt -- 运输日期
    ,multi_tenor_flg -- 多期限标志
    ,doc_diff_flg -- 单据差异标志
    ,submit_role_type_cd -- 提交角色类型代码
    ,doc_status_cd -- 单据状态代码
    ,ignore_discrp_flg -- 忽略不符点标志
    ,curr_cd -- 币种代码
    ,pay_tot_amt -- 付款总金额
    ,payer_type_cd -- 付款人类型代码
    ,acpt_flg -- 承兑标志
    ,income_bill_dt -- 来单日期
    ,chargeback_flg -- 退单标志
    ,trast_org_id -- 办理机构编号
    ,belong_org_id -- 所属机构编号
    ,load_bill_num -- 提单号
    ,nra_pay_flg -- NRA付款标志
    ,clear_chn_cd -- 清算渠道代码
    ,inv_id -- 发票编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222312'||P1.INR -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INR -- 源协议编号
    ,P1.OWNREF -- 票据业务编号
    ,P1.NAM -- 交易描述
    ,P1.OWNUSR -- 业务柜员编号
    ,P1.CREDAT -- 系统登记日期
    ,P1.OPNDAT -- 业务登记日期
    ,P1.CLSDAT -- 闭卷日期
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.PNTTYP END -- 父类业务类型代码
    ,P1.PNTINR -- 父类交易内部编号
    ,P1.PREDAT -- 寄单行寄单日期
    ,P1.SHPDAT -- 最迟装运日期
    ,P1.MATDAT -- 延期付款到期日期
    ,P1.RCVDAT -- 提单收到日期
    ,P1.DISDAT -- 不符点通知日期
    ,nvl(trim(P1.DOCFLG),'-') -- 单据类型代码
    ,nvl(trim(P1.REJFLG),'N') -- 拒付标志代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.APPROVCOD END -- 批准标志
    ,nvl(trim(P1.RELGODFLG),'N') -- 放货方式代码
    ,P1.RELGODDAT -- 授权放货日期
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.FREPAYFLG END -- 免付款交单标志
    ,nvl(trim(P1.ADVTYP),'-') -- 接收通知类型代码
    ,P1.EXPDAT -- 提货担保开立日期
    ,nvl(trim(P1.TRPDOCTYP),'-') -- 运输单据类型代码
    ,P1.TRADAT -- 运输日期
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.MATTXTFLG END -- 多期限标志
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.DSCINSFLG END -- 单据差异标志
    ,nvl(trim(P1.DOCPRBROL),'-') -- 提交角色类型代码
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.DOCSTA END -- 单据状态代码
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.IGNDISFLG END -- 忽略不符点标志
    ,nvl(trim(P1.TOTCUR),'-') -- 币种代码
    ,P1.TOTAMT -- 付款总金额
    ,nvl(trim(P1.PAYROL),'-') -- 付款人类型代码
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.ACPNOWFLG END -- 承兑标志
    ,P1.ORDDAT -- 来单日期
    ,CASE WHEN R9.TARGET_CD_VAL IS NOT NULL THEN R9.TARGET_CD_VAL ELSE '@'||P1.ADVDOCFLG END -- 退单标志
    ,P2.BRANCH -- 办理机构编号
    ,P3.BRANCH -- 所属机构编号
    ,P1.BLNUM -- 提单号
    ,CASE WHEN R10.TARGET_CD_VAL IS NOT NULL THEN R10.TARGET_CD_VAL ELSE '@'||P1.NRAFLG END -- NRA付款标志
    ,CASE WHEN R11.TARGET_CD_VAL IS NOT NULL THEN R11.TARGET_CD_VAL ELSE '@'||P1.QSQDBH END -- 清算渠道代码
    ,P1.INVNUM -- 发票编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_brd' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_brd p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PNTTYP = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ISBS'
        AND R1.SRC_TAB_EN_NAME= 'ISBS_BRD'
        AND R1.SRC_FIELD_EN_NAME= 'PNTTYP'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_IMP_LC_DOC_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PARENT_BUS_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.APPROVCOD = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ISBS'
        AND R2.SRC_TAB_EN_NAME= 'ISBS_BRD'
        AND R2.SRC_FIELD_EN_NAME= 'APPROVCOD'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_IMP_LC_DOC_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'APPRV_FLG'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.FREPAYFLG = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'ISBS'
        AND R3.SRC_TAB_EN_NAME= 'ISBS_BRD'
        AND R3.SRC_FIELD_EN_NAME= 'FREPAYFLG'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_IMP_LC_DOC_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'FREE_PAY_PRESENT_FLG'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.MATTXTFLG = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'ISBS'
        AND R4.SRC_TAB_EN_NAME= 'ISBS_BRD'
        AND R4.SRC_FIELD_EN_NAME= 'MATTXTFLG'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_IMP_LC_DOC_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'MULTI_TENOR_FLG'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.DSCINSFLG = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'ISBS'
        AND R5.SRC_TAB_EN_NAME= 'ISBS_BRD'
        AND R5.SRC_FIELD_EN_NAME= 'DSCINSFLG'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_IMP_LC_DOC_H'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'DOC_DIFF_FLG'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.DOCSTA = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'ISBS'
        AND R6.SRC_TAB_EN_NAME= 'ISBS_BRD'
        AND R6.SRC_FIELD_EN_NAME= 'DOCSTA'
        AND R6.TARGET_TAB_EN_NAME= 'AGT_IMP_LC_DOC_H'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'DOC_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.IGNDISFLG = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'ISBS'
        AND R7.SRC_TAB_EN_NAME= 'ISBS_BRD'
        AND R7.SRC_FIELD_EN_NAME= 'IGNDISFLG'
        AND R7.TARGET_TAB_EN_NAME= 'AGT_IMP_LC_DOC_H'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'IGNORE_DISCRP_FLG'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.ACPNOWFLG = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'ISBS'
        AND R8.SRC_TAB_EN_NAME= 'ISBS_BRD'
        AND R8.SRC_FIELD_EN_NAME= 'ACPNOWFLG'
        AND R8.TARGET_TAB_EN_NAME= 'AGT_IMP_LC_DOC_H'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'ACPT_FLG'
    left join ${iml_schema}.ref_pub_cd_map r9 on P1.ADVDOCFLG = R9.SRC_CODE_VAL
        AND R9.SORC_SYS_CD= 'ISBS'
        AND R9.SRC_TAB_EN_NAME= 'ISBS_BRD'
        AND R9.SRC_FIELD_EN_NAME= 'ADVDOCFLG'
        AND R9.TARGET_TAB_EN_NAME= 'AGT_IMP_LC_DOC_H'
        AND R9.TARGET_TAB_FIELD_EN_NAME= 'CHARGEBACK_FLG'
    left join ${iol_schema}.isbs_bch p2 on P1.BCHKEYINR=p2.inr
and p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_bch p3 on P1.BRANCHINR=p3.inr
and p3.start_dt <= to_date('${batch_date}','yyyymmdd') and p3.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r10 on P1.NRAFLG = R10.SRC_CODE_VAL
        AND R10.SORC_SYS_CD= 'ISBS'
        AND R10.SRC_TAB_EN_NAME= 'ISBS_BRD'
        AND R10.SRC_FIELD_EN_NAME= 'NRAFLG'
        AND R10.TARGET_TAB_EN_NAME= 'AGT_IMP_LC_DOC_H'
        AND R10.TARGET_TAB_FIELD_EN_NAME= 'NRA_PAY_FLG'
    left join ${iml_schema}.ref_pub_cd_map r11 on P1.QSQDBH = R11.SRC_CODE_VAL
        AND R11.SORC_SYS_CD= 'ISBS'
        AND R11.SRC_TAB_EN_NAME= 'ISBS_BRD'
        AND R11.SRC_FIELD_EN_NAME= 'QSQDBH'
        AND R11.TARGET_TAB_EN_NAME= 'AGT_IMP_LC_DOC_H'
        AND R11.TARGET_TAB_FIELD_EN_NAME= 'CLEAR_CHN_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_imp_lc_doc_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,bill_bus_id -- 票据业务编号
    ,tran_descb -- 交易描述
    ,bus_teller_id -- 业务柜员编号
    ,sys_rgst_dt -- 系统登记日期
    ,bus_rgst_dt -- 业务登记日期
    ,close_dt -- 闭卷日期
    ,parent_bus_type_cd -- 父类业务类型代码
    ,parent_tran_intnal_id -- 父类交易内部编号
    ,send_bill_bk_send_bill_dt -- 寄单行寄单日期
    ,latest_ship_dt -- 最迟装运日期
    ,delay_pay_exp_dt -- 延期付款到期日期
    ,load_bill_revid_dt -- 提单收到日期
    ,discrp_advise_dt -- 不符点通知日期
    ,doc_type_cd -- 单据类型代码
    ,refuse_pay_flg_cd -- 拒付标志代码
    ,apprv_flg -- 批准标志
    ,goods_way_cd -- 放货方式代码
    ,auth_goods_dt -- 授权放货日期
    ,free_pay_present_flg -- 免付款交单标志
    ,recv_advise_type_cd -- 接收通知类型代码
    ,pick_goods_guar_open_dt -- 提货担保开立日期
    ,traff_doc_type_cd -- 运输单据类型代码
    ,traff_dt -- 运输日期
    ,multi_tenor_flg -- 多期限标志
    ,doc_diff_flg -- 单据差异标志
    ,submit_role_type_cd -- 提交角色类型代码
    ,doc_status_cd -- 单据状态代码
    ,ignore_discrp_flg -- 忽略不符点标志
    ,curr_cd -- 币种代码
    ,pay_tot_amt -- 付款总金额
    ,payer_type_cd -- 付款人类型代码
    ,acpt_flg -- 承兑标志
    ,income_bill_dt -- 来单日期
    ,chargeback_flg -- 退单标志
    ,trast_org_id -- 办理机构编号
    ,belong_org_id -- 所属机构编号
    ,load_bill_num -- 提单号
    ,nra_pay_flg -- NRA付款标志
    ,clear_chn_cd -- 清算渠道代码
    ,inv_id -- 发票编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_imp_lc_doc_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,bill_bus_id -- 票据业务编号
    ,tran_descb -- 交易描述
    ,bus_teller_id -- 业务柜员编号
    ,sys_rgst_dt -- 系统登记日期
    ,bus_rgst_dt -- 业务登记日期
    ,close_dt -- 闭卷日期
    ,parent_bus_type_cd -- 父类业务类型代码
    ,parent_tran_intnal_id -- 父类交易内部编号
    ,send_bill_bk_send_bill_dt -- 寄单行寄单日期
    ,latest_ship_dt -- 最迟装运日期
    ,delay_pay_exp_dt -- 延期付款到期日期
    ,load_bill_revid_dt -- 提单收到日期
    ,discrp_advise_dt -- 不符点通知日期
    ,doc_type_cd -- 单据类型代码
    ,refuse_pay_flg_cd -- 拒付标志代码
    ,apprv_flg -- 批准标志
    ,goods_way_cd -- 放货方式代码
    ,auth_goods_dt -- 授权放货日期
    ,free_pay_present_flg -- 免付款交单标志
    ,recv_advise_type_cd -- 接收通知类型代码
    ,pick_goods_guar_open_dt -- 提货担保开立日期
    ,traff_doc_type_cd -- 运输单据类型代码
    ,traff_dt -- 运输日期
    ,multi_tenor_flg -- 多期限标志
    ,doc_diff_flg -- 单据差异标志
    ,submit_role_type_cd -- 提交角色类型代码
    ,doc_status_cd -- 单据状态代码
    ,ignore_discrp_flg -- 忽略不符点标志
    ,curr_cd -- 币种代码
    ,pay_tot_amt -- 付款总金额
    ,payer_type_cd -- 付款人类型代码
    ,acpt_flg -- 承兑标志
    ,income_bill_dt -- 来单日期
    ,chargeback_flg -- 退单标志
    ,trast_org_id -- 办理机构编号
    ,belong_org_id -- 所属机构编号
    ,load_bill_num -- 提单号
    ,nra_pay_flg -- NRA付款标志
    ,clear_chn_cd -- 清算渠道代码
    ,inv_id -- 发票编号
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
    ,nvl(n.bill_bus_id, o.bill_bus_id) as bill_bus_id -- 票据业务编号
    ,nvl(n.tran_descb, o.tran_descb) as tran_descb -- 交易描述
    ,nvl(n.bus_teller_id, o.bus_teller_id) as bus_teller_id -- 业务柜员编号
    ,nvl(n.sys_rgst_dt, o.sys_rgst_dt) as sys_rgst_dt -- 系统登记日期
    ,nvl(n.bus_rgst_dt, o.bus_rgst_dt) as bus_rgst_dt -- 业务登记日期
    ,nvl(n.close_dt, o.close_dt) as close_dt -- 闭卷日期
    ,nvl(n.parent_bus_type_cd, o.parent_bus_type_cd) as parent_bus_type_cd -- 父类业务类型代码
    ,nvl(n.parent_tran_intnal_id, o.parent_tran_intnal_id) as parent_tran_intnal_id -- 父类交易内部编号
    ,nvl(n.send_bill_bk_send_bill_dt, o.send_bill_bk_send_bill_dt) as send_bill_bk_send_bill_dt -- 寄单行寄单日期
    ,nvl(n.latest_ship_dt, o.latest_ship_dt) as latest_ship_dt -- 最迟装运日期
    ,nvl(n.delay_pay_exp_dt, o.delay_pay_exp_dt) as delay_pay_exp_dt -- 延期付款到期日期
    ,nvl(n.load_bill_revid_dt, o.load_bill_revid_dt) as load_bill_revid_dt -- 提单收到日期
    ,nvl(n.discrp_advise_dt, o.discrp_advise_dt) as discrp_advise_dt -- 不符点通知日期
    ,nvl(n.doc_type_cd, o.doc_type_cd) as doc_type_cd -- 单据类型代码
    ,nvl(n.refuse_pay_flg_cd, o.refuse_pay_flg_cd) as refuse_pay_flg_cd -- 拒付标志代码
    ,nvl(n.apprv_flg, o.apprv_flg) as apprv_flg -- 批准标志
    ,nvl(n.goods_way_cd, o.goods_way_cd) as goods_way_cd -- 放货方式代码
    ,nvl(n.auth_goods_dt, o.auth_goods_dt) as auth_goods_dt -- 授权放货日期
    ,nvl(n.free_pay_present_flg, o.free_pay_present_flg) as free_pay_present_flg -- 免付款交单标志
    ,nvl(n.recv_advise_type_cd, o.recv_advise_type_cd) as recv_advise_type_cd -- 接收通知类型代码
    ,nvl(n.pick_goods_guar_open_dt, o.pick_goods_guar_open_dt) as pick_goods_guar_open_dt -- 提货担保开立日期
    ,nvl(n.traff_doc_type_cd, o.traff_doc_type_cd) as traff_doc_type_cd -- 运输单据类型代码
    ,nvl(n.traff_dt, o.traff_dt) as traff_dt -- 运输日期
    ,nvl(n.multi_tenor_flg, o.multi_tenor_flg) as multi_tenor_flg -- 多期限标志
    ,nvl(n.doc_diff_flg, o.doc_diff_flg) as doc_diff_flg -- 单据差异标志
    ,nvl(n.submit_role_type_cd, o.submit_role_type_cd) as submit_role_type_cd -- 提交角色类型代码
    ,nvl(n.doc_status_cd, o.doc_status_cd) as doc_status_cd -- 单据状态代码
    ,nvl(n.ignore_discrp_flg, o.ignore_discrp_flg) as ignore_discrp_flg -- 忽略不符点标志
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.pay_tot_amt, o.pay_tot_amt) as pay_tot_amt -- 付款总金额
    ,nvl(n.payer_type_cd, o.payer_type_cd) as payer_type_cd -- 付款人类型代码
    ,nvl(n.acpt_flg, o.acpt_flg) as acpt_flg -- 承兑标志
    ,nvl(n.income_bill_dt, o.income_bill_dt) as income_bill_dt -- 来单日期
    ,nvl(n.chargeback_flg, o.chargeback_flg) as chargeback_flg -- 退单标志
    ,nvl(n.trast_org_id, o.trast_org_id) as trast_org_id -- 办理机构编号
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.load_bill_num, o.load_bill_num) as load_bill_num -- 提单号
    ,nvl(n.nra_pay_flg, o.nra_pay_flg) as nra_pay_flg -- NRA付款标志
    ,nvl(n.clear_chn_cd, o.clear_chn_cd) as clear_chn_cd -- 清算渠道代码
    ,nvl(n.inv_id, o.inv_id) as inv_id -- 发票编号
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
from ${iml_schema}.agt_imp_lc_doc_h_isbsf1_tm n
    full join (select * from ${iml_schema}.agt_imp_lc_doc_h_isbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        or o.bill_bus_id <> n.bill_bus_id
        or o.tran_descb <> n.tran_descb
        or o.bus_teller_id <> n.bus_teller_id
        or o.sys_rgst_dt <> n.sys_rgst_dt
        or o.bus_rgst_dt <> n.bus_rgst_dt
        or o.close_dt <> n.close_dt
        or o.parent_bus_type_cd <> n.parent_bus_type_cd
        or o.parent_tran_intnal_id <> n.parent_tran_intnal_id
        or o.send_bill_bk_send_bill_dt <> n.send_bill_bk_send_bill_dt
        or o.latest_ship_dt <> n.latest_ship_dt
        or o.delay_pay_exp_dt <> n.delay_pay_exp_dt
        or o.load_bill_revid_dt <> n.load_bill_revid_dt
        or o.discrp_advise_dt <> n.discrp_advise_dt
        or o.doc_type_cd <> n.doc_type_cd
        or o.refuse_pay_flg_cd <> n.refuse_pay_flg_cd
        or o.apprv_flg <> n.apprv_flg
        or o.goods_way_cd <> n.goods_way_cd
        or o.auth_goods_dt <> n.auth_goods_dt
        or o.free_pay_present_flg <> n.free_pay_present_flg
        or o.recv_advise_type_cd <> n.recv_advise_type_cd
        or o.pick_goods_guar_open_dt <> n.pick_goods_guar_open_dt
        or o.traff_doc_type_cd <> n.traff_doc_type_cd
        or o.traff_dt <> n.traff_dt
        or o.multi_tenor_flg <> n.multi_tenor_flg
        or o.doc_diff_flg <> n.doc_diff_flg
        or o.submit_role_type_cd <> n.submit_role_type_cd
        or o.doc_status_cd <> n.doc_status_cd
        or o.ignore_discrp_flg <> n.ignore_discrp_flg
        or o.curr_cd <> n.curr_cd
        or o.pay_tot_amt <> n.pay_tot_amt
        or o.payer_type_cd <> n.payer_type_cd
        or o.acpt_flg <> n.acpt_flg
        or o.income_bill_dt <> n.income_bill_dt
        or o.chargeback_flg <> n.chargeback_flg
        or o.trast_org_id <> n.trast_org_id
        or o.belong_org_id <> n.belong_org_id
        or o.load_bill_num <> n.load_bill_num
        or o.nra_pay_flg <> n.nra_pay_flg
        or o.clear_chn_cd <> n.clear_chn_cd
        or o.inv_id <> n.inv_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_imp_lc_doc_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,bill_bus_id -- 票据业务编号
    ,tran_descb -- 交易描述
    ,bus_teller_id -- 业务柜员编号
    ,sys_rgst_dt -- 系统登记日期
    ,bus_rgst_dt -- 业务登记日期
    ,close_dt -- 闭卷日期
    ,parent_bus_type_cd -- 父类业务类型代码
    ,parent_tran_intnal_id -- 父类交易内部编号
    ,send_bill_bk_send_bill_dt -- 寄单行寄单日期
    ,latest_ship_dt -- 最迟装运日期
    ,delay_pay_exp_dt -- 延期付款到期日期
    ,load_bill_revid_dt -- 提单收到日期
    ,discrp_advise_dt -- 不符点通知日期
    ,doc_type_cd -- 单据类型代码
    ,refuse_pay_flg_cd -- 拒付标志代码
    ,apprv_flg -- 批准标志
    ,goods_way_cd -- 放货方式代码
    ,auth_goods_dt -- 授权放货日期
    ,free_pay_present_flg -- 免付款交单标志
    ,recv_advise_type_cd -- 接收通知类型代码
    ,pick_goods_guar_open_dt -- 提货担保开立日期
    ,traff_doc_type_cd -- 运输单据类型代码
    ,traff_dt -- 运输日期
    ,multi_tenor_flg -- 多期限标志
    ,doc_diff_flg -- 单据差异标志
    ,submit_role_type_cd -- 提交角色类型代码
    ,doc_status_cd -- 单据状态代码
    ,ignore_discrp_flg -- 忽略不符点标志
    ,curr_cd -- 币种代码
    ,pay_tot_amt -- 付款总金额
    ,payer_type_cd -- 付款人类型代码
    ,acpt_flg -- 承兑标志
    ,income_bill_dt -- 来单日期
    ,chargeback_flg -- 退单标志
    ,trast_org_id -- 办理机构编号
    ,belong_org_id -- 所属机构编号
    ,load_bill_num -- 提单号
    ,nra_pay_flg -- NRA付款标志
    ,clear_chn_cd -- 清算渠道代码
    ,inv_id -- 发票编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_imp_lc_doc_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,bill_bus_id -- 票据业务编号
    ,tran_descb -- 交易描述
    ,bus_teller_id -- 业务柜员编号
    ,sys_rgst_dt -- 系统登记日期
    ,bus_rgst_dt -- 业务登记日期
    ,close_dt -- 闭卷日期
    ,parent_bus_type_cd -- 父类业务类型代码
    ,parent_tran_intnal_id -- 父类交易内部编号
    ,send_bill_bk_send_bill_dt -- 寄单行寄单日期
    ,latest_ship_dt -- 最迟装运日期
    ,delay_pay_exp_dt -- 延期付款到期日期
    ,load_bill_revid_dt -- 提单收到日期
    ,discrp_advise_dt -- 不符点通知日期
    ,doc_type_cd -- 单据类型代码
    ,refuse_pay_flg_cd -- 拒付标志代码
    ,apprv_flg -- 批准标志
    ,goods_way_cd -- 放货方式代码
    ,auth_goods_dt -- 授权放货日期
    ,free_pay_present_flg -- 免付款交单标志
    ,recv_advise_type_cd -- 接收通知类型代码
    ,pick_goods_guar_open_dt -- 提货担保开立日期
    ,traff_doc_type_cd -- 运输单据类型代码
    ,traff_dt -- 运输日期
    ,multi_tenor_flg -- 多期限标志
    ,doc_diff_flg -- 单据差异标志
    ,submit_role_type_cd -- 提交角色类型代码
    ,doc_status_cd -- 单据状态代码
    ,ignore_discrp_flg -- 忽略不符点标志
    ,curr_cd -- 币种代码
    ,pay_tot_amt -- 付款总金额
    ,payer_type_cd -- 付款人类型代码
    ,acpt_flg -- 承兑标志
    ,income_bill_dt -- 来单日期
    ,chargeback_flg -- 退单标志
    ,trast_org_id -- 办理机构编号
    ,belong_org_id -- 所属机构编号
    ,load_bill_num -- 提单号
    ,nra_pay_flg -- NRA付款标志
    ,clear_chn_cd -- 清算渠道代码
    ,inv_id -- 发票编号
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
    ,o.bill_bus_id -- 票据业务编号
    ,o.tran_descb -- 交易描述
    ,o.bus_teller_id -- 业务柜员编号
    ,o.sys_rgst_dt -- 系统登记日期
    ,o.bus_rgst_dt -- 业务登记日期
    ,o.close_dt -- 闭卷日期
    ,o.parent_bus_type_cd -- 父类业务类型代码
    ,o.parent_tran_intnal_id -- 父类交易内部编号
    ,o.send_bill_bk_send_bill_dt -- 寄单行寄单日期
    ,o.latest_ship_dt -- 最迟装运日期
    ,o.delay_pay_exp_dt -- 延期付款到期日期
    ,o.load_bill_revid_dt -- 提单收到日期
    ,o.discrp_advise_dt -- 不符点通知日期
    ,o.doc_type_cd -- 单据类型代码
    ,o.refuse_pay_flg_cd -- 拒付标志代码
    ,o.apprv_flg -- 批准标志
    ,o.goods_way_cd -- 放货方式代码
    ,o.auth_goods_dt -- 授权放货日期
    ,o.free_pay_present_flg -- 免付款交单标志
    ,o.recv_advise_type_cd -- 接收通知类型代码
    ,o.pick_goods_guar_open_dt -- 提货担保开立日期
    ,o.traff_doc_type_cd -- 运输单据类型代码
    ,o.traff_dt -- 运输日期
    ,o.multi_tenor_flg -- 多期限标志
    ,o.doc_diff_flg -- 单据差异标志
    ,o.submit_role_type_cd -- 提交角色类型代码
    ,o.doc_status_cd -- 单据状态代码
    ,o.ignore_discrp_flg -- 忽略不符点标志
    ,o.curr_cd -- 币种代码
    ,o.pay_tot_amt -- 付款总金额
    ,o.payer_type_cd -- 付款人类型代码
    ,o.acpt_flg -- 承兑标志
    ,o.income_bill_dt -- 来单日期
    ,o.chargeback_flg -- 退单标志
    ,o.trast_org_id -- 办理机构编号
    ,o.belong_org_id -- 所属机构编号
    ,o.load_bill_num -- 提单号
    ,o.nra_pay_flg -- NRA付款标志
    ,o.clear_chn_cd -- 清算渠道代码
    ,o.inv_id -- 发票编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_imp_lc_doc_h_isbsf1_bk o
    left join ${iml_schema}.agt_imp_lc_doc_h_isbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_imp_lc_doc_h_isbsf1_cl d
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
--truncate table ${iml_schema}.agt_imp_lc_doc_h;
alter table ${iml_schema}.agt_imp_lc_doc_h truncate partition for ('isbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_imp_lc_doc_h exchange subpartition p_isbsf1_19000101 with table ${iml_schema}.agt_imp_lc_doc_h_isbsf1_cl;
alter table ${iml_schema}.agt_imp_lc_doc_h exchange subpartition p_isbsf1_20991231 with table ${iml_schema}.agt_imp_lc_doc_h_isbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_imp_lc_doc_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_imp_lc_doc_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_imp_lc_doc_h_isbsf1_op purge;
drop table ${iml_schema}.agt_imp_lc_doc_h_isbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_imp_lc_doc_h_isbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_imp_lc_doc_h', partname => 'p_isbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
