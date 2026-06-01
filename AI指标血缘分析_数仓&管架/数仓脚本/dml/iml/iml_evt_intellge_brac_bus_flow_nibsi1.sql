/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_intellge_brac_bus_flow_nibsi1
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
alter table ${iml_schema}.evt_intellge_brac_bus_flow add partition p_nibsi1 values ('nibsi1')(
        subpartition p_nibsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_intellge_brac_bus_flow modify partition p_nibsi1
    add subpartition p_nibsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

set serveroutput on
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
for i in 0 .. 14 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_subpartitions where table_name = upper(''evt_intellge_brac_bus_flow'') and subpartition_name = ''P_NIBSI1_'||bat_dt||''' ';
    execute immediate v_sql into v_p_exists;
    if v_p_exists = 1 then 
        v_sql := 'alter table iml.evt_intellge_brac_bus_flow truncate subpartition P_NIBSI1_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    else 
        v_sql := 'alter table iml.evt_intellge_brac_bus_flow modify partition p_nibsi1 add subpartition P_NIBSI1_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        execute immediate v_sql;
    end if;
      end loop;
end;
/
whenever sqlerror exit sql.sqlcode;
insert into ${iml_schema}.evt_intellge_brac_bus_flow(
    evt_id -- 事件编号
    ,bus_flow_num -- 业务流水号
    ,lp_id -- 法人编号
    ,chn_dt -- 渠道日期
    ,ova_flow_num -- 全局流水号
    ,ups_flow_num -- 上游流水号
    ,sys_flow_num -- 系统流水号
    ,serv_flow_num -- 服务流水号
    ,plat_flow_num -- 平台流水号
    ,sorc_sys_id -- 源系统编号
    ,chn_id -- 渠道编号
    ,chn_tm -- 渠道时间
    ,chn_ip_addr -- 渠道IP地址
    ,chn_tran_code -- 渠道交易编码
    ,chn_tran_name -- 渠道交易名称
    ,tran_type_cd -- 交易类型代码
    ,tran_org_id -- 交易机构编号
    ,tran_org_name -- 交易机构名称
    ,high_low_teller_flg -- 高低柜标志
    ,tran_teller_id -- 交易柜员编号
    ,tran_teller_name -- 交易柜员姓名
    ,auth_teller_id -- 授权柜员编号
    ,auth_teller_name -- 授权柜员姓名
    ,teller_belong_org_id -- 柜员所属机构编号
    ,camp_emply_id -- 营销员工编号
    ,auth_flow_num -- 授权流水号
    ,auth_mode_cd -- 授权模式代码
    ,long_flow_tran_flg -- 长流程交易标志
    ,cust_type -- 客户类型代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,acct_id -- 账户编号
    ,acct_num_name -- 账号名称
    ,tran_curr_cd -- 交易币种代码
    ,tran_amt -- 交易金额
    ,debit_crdt_flg -- 借贷标志
    ,cash_trans_flg -- 现转标志
    ,cust_netw_vrfction_rest_cd -- 客户联网核查结果代码
    ,face_recn_rest_cd -- 人脸识别结果代码
    ,face_recn_score -- 人脸识别分数
    ,cntpty_cate_cd -- 交易对手类别代码
    ,cntpty_id -- 交易对手编号
    ,cntpty_cust_acct_num -- 交易对手客户账号
    ,cntpty_name -- 交易对手名称
    ,agent_flg -- 代理标志
    ,agent_name -- 代办人名称
    ,agent_cert_type_cd -- 代办人证件类型代码
    ,agent_cert_no -- 代办人证件号码
    ,agent_cont_num -- 代办人联系号码
    ,agent_nation_cd -- 代办人国籍代码
    ,agent_gender_cd -- 代办人性别代码
    ,agent_career_cd -- 代办人职业代码
    ,agent_licen_issue_autho_addr -- 代办人发证机关地址
    ,agent_cont_addr -- 代办人联系地址
    ,agent_cert_start_dt -- 代办人证件开始日期
    ,agent_cert_exp_dt -- 交易代办人证件到期日期
    ,agent_netw_vrfction_rest_cd -- 代办人联网核查结果代码
    ,agent_face_recn_rest_cd -- 代办人人脸识别结果代码
    ,agent_face_recn_score -- 代办人人脸识别分数
    ,agent_rs_descb -- 代办原因描述
    ,vouch_matrl_qtty -- 凭证资料数量
    ,blend_way_cd -- 勾兑方式代码
    ,blend_status_cd -- 勾兑状态代码
    ,tran_status_cd -- 交易状态代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_effect_dt -- 交易开始时间
    ,tran_invalid_dt -- 交易结束时间
    ,descb -- 描述
    ,bus_apv_flow_num -- 业务审批流水号
    ,rela_bus_flow_num -- 关联业务流水号
    ,high_risk_flg -- 高风险标志
    ,manual_blend_flg -- 手工勾兑标志
    ,spcs_turn_loc_flg -- 后援中心转本地标志
    ,brch_init_appl_loc_flg -- 分行主动申请本地标志
    ,spcs_appl_flg -- 后援申请撤退标志
    ,blip_scene_code -- 影像场景码
    ,blip_id -- 影像编号
    ,app_num -- 应用编号
    ,once_fin_serv_flg -- 一次性金融服务标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102073'||TX_SEQ_NUM -- 事件编号
    ,P1.TX_SEQ_NUM -- 业务流水号
    ,'9999' -- 法人编号
    ,P1.CHANNELDATE -- 渠道日期
    ,P1.CORE_TRAN_FLOW_NUM -- 全局流水号
    ,P1.CHAN_BIZ_SEQ_NUM -- 上游流水号
    ,P1.BACKSERIALNUM -- 系统流水号
    ,P1.CUSTSERIALNUM -- 服务流水号
    ,P1.P_BIZ_SEQ_NUM -- 平台流水号
    ,P1.SYS_NUM -- 源系统编号
    ,P1.CHAN_NUM -- 渠道编号
    ,P1.CHANNELTIME -- 渠道时间
    ,P1.CHANNELIP -- 渠道IP地址
    ,P1.CHANNELTRANCODE -- 渠道交易编码
    ,P1.CHANNELTRANNAME -- 渠道交易名称
    ,P1.CHANNELTRANTYPE -- 交易类型代码
    ,P1.TX_ORG_NUM -- 交易机构编号
    ,P1.TX_ORG_NAME -- 交易机构名称
    ,P1.TELLER_FLAG -- 高低柜标志
    ,P1.TX_TELLER_NUM -- 交易柜员编号
    ,P1.TX_TELLER_NAME -- 交易柜员姓名
    ,P1.AUTH_TEL_NUM -- 授权柜员编号
    ,P1.AUTH_TEL_NAME -- 授权柜员姓名
    ,P1.ATTACHORGAN -- 柜员所属机构编号
    ,P1.MARKWORKNUM -- 营销员工编号
    ,P1.AUTH_FLOW_NUM -- 授权流水号
    ,P1.AUTH_MOULD -- 授权模式代码
    ,P1.ISLANGTRAN -- 长流程交易标志
    ,P1.CUST_TYPE_CD -- 客户类型代码
    ,P1.CUST_NUM -- 客户编号
    ,P1.CN_NAME -- 客户名称
    ,P1.CERT_TYPE_CD -- 证件类型代码
    ,P1.CERT_NUM -- 证件号码
    ,P1.ACCT_NUM -- 账户编号
    ,P1.ACCT_NAME -- 账号名称
    ,P1.TX_CURR_CD -- 交易币种代码
    ,P1.TX_AMT -- 交易金额
    ,P1.DEBIT_CRDT_IND -- 借贷标志
    ,nvl(trim(P1.CASH_TRANS_FLG),'-') -- 现转标志
    ,P1.NETWORKCHKRESULT -- 客户联网核查结果代码
    ,P1.FACEIDENTRESULT -- 人脸识别结果代码
    ,NVL(TRIM(P1.FACEIDENTSCORE),0) -- 人脸识别分数
    ,P1.CNTPTY_TYPE_CD -- 交易对手类别代码
    ,P1.CNTPTY_ID -- 交易对手编号
    ,P1.TX_CNTPTY_ACCT_NUM -- 交易对手客户账号
    ,P1.TX_CNTPTY_NAME -- 交易对手名称
    ,P1.ISAGENT -- 代理标志
    ,P1.AGENT_PERSON_NAME -- 代办人名称
    ,P1.AGENT_PERSON_CERT_TYPE_CD -- 代办人证件类型代码
    ,P1.AGENT_PERSON_CERT_NUM -- 代办人证件号码
    ,P1.AGENT_PERSON_TEL_NUM -- 代办人联系号码
    ,nvl(trim(P1.AGENT_PERSON_NATION_CD),'XXX') -- 代办人国籍代码
    ,P1.AGENT_GENDER_CD -- 代办人性别代码
    ,P1.AGENT_CAREER_CD -- 代办人职业代码
    ,P1.AGENT_PERSON_AUTH_ADR -- 代办人发证机关地址
    ,P1.AGENT_PERSON_CONTACT_ADR -- 代办人联系地址
    ,P1.AGENT_PERSON_START_DT -- 代办人证件开始日期
    ,P1.AGENT_PERSON_END_DT -- 交易代办人证件到期日期
    ,P1.AGENT_PERSON_NETWORKCHK_RET -- 代办人联网核查结果代码
    ,P1.AGENT_PERSON_FACEIDENT_RES -- 代办人人脸识别结果代码
    ,NVL(TRIM(P1.AGENT_PERSON_FACEIDENT_SCORE),0) -- 代办人人脸识别分数
    ,0 -- 代办原因描述
    ,P1.VOUCHERNUM -- 凭证资料数量
    ,P1.BLENDINGTYPE -- 勾兑方式代码
    ,P1.BLENDINGSTATU -- 勾兑状态代码
    ,P1.TRANSTATE -- 交易状态代码
    ,P1.P_WORKDATE -- 交易日期
    ,P1.P_WORKTIME -- 交易时间
    ,P1.TRANSTARTTIME -- 交易开始时间
    ,P1.TRANENDTIME -- 交易结束时间
    ,P1.PURPOSE -- 描述
    ,P1.APPORVENO -- 业务审批流水号
    ,P1.REUNIQUE_SEQ_NUM -- 关联业务流水号
    ,substr (trim(P1.KEYBUSINESS),1,1) -- 高风险标志
    ,substr (trim(P1.KEYBUSINESS),2,1) -- 手工勾兑标志
    ,substr (trim(P1.KEYBUSINESS),3,1) -- 后援中心转本地标志
    ,substr (trim(P1.KEYBUSINESS),4,1) -- 分行主动申请本地标志
    ,substr (trim(P1.KEYBUSINESS),5,1) -- 后援申请撤退标志
    ,P1.BIZ_SCENE -- 影像场景码
    ,P1.BLIP_ID -- 影像编号
    ,P1.APP_NUM -- 应用编号
    ,decode(trim(P1.FINANCEFLAG),'Y','1','N','0','','-',P1.FINANCEFLAG) -- 一次性金融服务标志
    ,p1.etl_dt as etl_dt -- ETL处理日期
    ,'nibs_ib_log_business_log' -- 源表名称
    ,'nibsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nibs_ib_log_business_log p1
where  1 = 1 
     and p1.etl_dt >= to_date('${batch_date}','yyyymmdd') - 14  
     and p1.etl_dt <= to_date('${batch_date}','yyyymmdd')
;
commit;


merge into ${iml_schema}.evt_intellge_brac_bus_flow  t1  
-- 3.2 truncate target table batch_date partition
  using (select t.*,row_number() over(partition by tx_seq_num, orig_channeldate order by channeltime desc) as rn
                  from ${iol_schema}.nibs_ib_log_agentfill_info t 
                where t.etl_dt = to_date('${batch_date}', 'yyyymmdd')) t2  
                       on (t1.bus_flow_num=t2.tx_seq_num 
                     and t1.chn_dt=t2.orig_channeldate
                     and t2.rn=1)
  when matched then update set 
                t1.agent_flg                                                =t2.isagent
                ,t1.agent_name                                          =t2.agent_person_name
                ,t1.agent_cert_type_cd                                =t2.agent_person_cert_type_cd
                ,t1.agent_cert_no                                        =t2.agent_person_cert_num
                ,t1.agent_cont_num                                    =t2.agent_person_tel_num
                ,t1.agent_nation_cd                                    =nvl(trim(t2.agent_person_nation_cd),'XXX')
                ,t1.agent_gender_cd                                   =t2.agent_gender_cd
                ,t1.agent_licen_issue_autho_addr                =t2.agent_person_auth_adr
                ,t1.agent_cert_start_dt                                =decode(t2.agent_person_start_dt,' ',to_date('00010101', 'yyyymmdd'),t2.agent_person_start_dt)
                ,t1.agent_cert_exp_dt                                  =decode(t2.agent_person_end_dt,' ',to_date('00010101', 'yyyymmdd'),t2.agent_person_end_dt)
where t1.etl_dt in (select distinct orig_channeldate from ${iol_schema}.nibs_ib_log_agentfill_info where etl_dt = to_date('${batch_date}', 'yyyymmdd'));

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_intellge_brac_bus_flow to ${iml_schema};

-- 4.2 drop tm table

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_intellge_brac_bus_flow', partname => 'p_nibsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);